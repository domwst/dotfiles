#!/usr/bin/env python3
"""Send an explicit frontend review packet to OpenCode and preserve the result."""

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


def arguments():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--brief", required=True, type=Path)
    parser.add_argument("--source", action="append", default=[], type=Path)
    parser.add_argument("--image", action="append", default=[], type=Path)
    parser.add_argument("--model", default="openrouter/z-ai/glm-5.3-flash")
    parser.add_argument("--output", type=Path, help="New directory; must not exist")
    parser.add_argument("--timeout", type=int, default=600, help="Seconds (default: 600)")
    args = parser.parse_args()
    if not args.source and not args.image:
        parser.error("provide at least one --source or --image")
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    return args


def collect(args):
    brief = args.brief.read_text(encoding="utf-8")
    if not brief.strip():
        raise ValueError("the brief is empty")
    sources = [(p.resolve(), p.read_text(encoding="utf-8")) for p in args.source]
    images = []
    for path in args.image:
        if path.suffix.lower() not in {".png", ".jpg", ".jpeg", ".webp"}:
            raise ValueError(f"unsupported image type: {path}; use PNG, JPEG, or WebP")
        images.append((path.resolve(), path.read_bytes()))
        if not images[-1][1]:
            raise ValueError(f"image is empty: {path}")
    return brief, sources, images


def parse_events(path):
    texts, errors, sessions, finishes = [], [], set(), []
    malformed = 0
    tool_calls = 0
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        if not line.strip():
            continue
        try:
            event = json.loads(line)
            if not isinstance(event, dict):
                raise ValueError("not an event object")
            part = event.get("part") or {}
            if not isinstance(part, dict):
                raise ValueError("not a part object")
        except ValueError:
            malformed += 1
            continue
        if event.get("sessionID"):
            sessions.add(event["sessionID"])
        kind = event.get("type")
        if kind == "text" and isinstance(part.get("text"), str):
            texts.append(part["text"])
        elif kind == "error":
            errors.append(event)
        elif kind == "step_finish":
            finishes.append(part.get("reason"))
        elif kind == "tool_use":
            tool_calls += 1
    return "\n\n".join(texts), {
        "sessions": sorted(sessions),
        "error_events": errors,
        "malformed_events": malformed,
        "finish_reasons": finishes,
        "tool_calls": tool_calls,
    }


def main():
    args = arguments()
    try:
        brief, sources, images = collect(args)
        instructions = (Path(__file__).resolve().parent.parent / "references" /
                        "review-prompt.txt").read_text(encoding="utf-8")
        executable = shutil.which("opencode")
        if not executable:
            raise ValueError("opencode is not on PATH")
        if args.output:
            output = args.output.resolve()
            output.mkdir(parents=True, exist_ok=False)
        else:
            output = Path(tempfile.mkdtemp(prefix="frontend-review-")).resolve()
    except (OSError, ValueError) as exc:
        print(f"Cannot prepare review: {exc}", file=sys.stderr)
        return 2

    print(f"Review directory: {output}", flush=True)
    prompt = [instructions, "TASK CONTEXT AND CAPTURE CAPTIONS", brief]
    prompt.append("EVIDENCE MODE: rendered screenshots" if images else
                  "EVIDENCE MODE: source-only; no visual inspection is possible")
    attachments = []
    for index, (path, data) in enumerate(images, 1):
        copy = output / f"image-{index:02d}-{path.name}"
        copy.write_bytes(data)
        attachments.append(copy)
        prompt.append(f"Image {index}: {copy.name}; original capture: {path}")
    for path, content in sources:
        prompt.extend([f"BEGIN SOURCE: {path}", content, f"END SOURCE: {path}"])
    request = "\n\n".join(prompt)
    (output / "request.txt").write_text(request, encoding="utf-8")

    # stdin avoids shell interpolation and per-argument limits for large diffs.
    command = [executable, "run", "--pure", "--agent", "plan", "--model", args.model,
               "--format", "json", "--title", "Independent frontend review"]
    for path in attachments:
        command.extend(["--file", str(path)])
    env = os.environ.copy()
    env["OPENCODE_CONFIG_CONTENT"] = json.dumps({
        "permission": {"*": "deny"},
        "agent": {"plan": {"permission": {"*": "deny"}}},
    })
    status = {"model": args.model, "exit_code": None, "execution_error": None}
    events = output / "events.jsonl"
    try:
        with events.open("w", encoding="utf-8") as out, \
                (output / "stderr.txt").open("w", encoding="utf-8") as err:
            result = subprocess.run(command, input=request, text=True, encoding="utf-8",
                                    cwd=output, env=env, stdout=out, stderr=err,
                                    timeout=args.timeout, check=False)
            status["exit_code"] = result.returncode
    except (OSError, subprocess.TimeoutExpired, KeyboardInterrupt) as exc:
        status["execution_error"] = type(exc).__name__ + ": " + str(exc)
    review, parsed = parse_events(events)
    status.update(parsed)
    status["complete"] = bool(
        status["exit_code"] == 0 and not status["execution_error"]
        and review.strip() and not status["error_events"]
        and not status["malformed_events"] and not status["tool_calls"]
        and status["finish_reasons"] and status["finish_reasons"][-1] == "stop"
    )
    (output / "review.txt").write_text(review, encoding="utf-8")
    (output / "status.json").write_text(json.dumps(status, indent=2) + "\n", encoding="utf-8")
    if not status["complete"]:
        print(f"Review incomplete. Inspect {output / 'status.json'}, events.jsonl, and "
              "stderr.txt; any review.txt is partial. No automatic retry.", file=sys.stderr)
        return 1
    print(f"Review complete: {output / 'review.txt'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
