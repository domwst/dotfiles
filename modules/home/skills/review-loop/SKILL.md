---
name: review-loop
description: Cross-model review loop for a pushed GitLab MR. Delegate a fresh agent for a review each round, address findings, push, repeat until approved. Use when the user asks for a review loop.
---

# Cross-model review loop

Use either `gpt-6.1-sol xhigh` or `opus-5.5 xhigh` for review if not asked otherwise.
Never use a reviewer model from the same family (i.e. if you're an Anthropic model
don't use `opus` and vice versa).

Preconditions: branch pushed, MR exists. You own the loop; the reviewer is a T3
child task.

1. Each round N, call `delegate_task` with `role: "review"`, `mode: "async"`,
   `clientRequestId: "<repo>-mr<iid>-r<N>"`, and a task prompt containing:
   - MR URL, target branch, head SHA, and the original feature brief
   - every prior finding with your response (fixed in `<sha>` / rejected because
     …)
   - instructions: review the diff; do not edit files, commit, or push; post each
     new finding as an inline GitLab discussion via `glab`; if you still disagree
     with a rejection, reply on that discussion; finish with a fenced JSON block
     `{"verdict": "approve"|"changes", "findings": [{"discussion_id", "severity":
     "blocker|major|minor|nit", "file", "line", "summary"}]}`
   Then end your turn. The child's completion wakes you; do not poll.
2. On wake: fix or reject (with a concrete reason) every blocker/major/minor
   finding; fix nits if cheap. Reply on each discussion and resolve the fixed
   ones. Run tests, commit, push.
3. Stop when the verdict is approve with no blocker/major findings, after round
   3, or when the same finding is contested twice. Report to the user: rounds run,
   what changed, and open disagreements with both sides' arguments.
