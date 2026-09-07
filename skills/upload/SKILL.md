---
name: upload
description: Publish HTML reports, static pages, PDFs, and other documents using the user's upload command. Use when a task calls for a hosted report, shareable URL, or document upload.
---

# Publish reports with upload

Use the `upload` command on PATH to publish finished reports and documents to the
user's configured Zipline instance. Prefer this workflow when the task calls for
a hosted deliverable and the user has not specified another destination. A request
to create a local file alone does not require publishing it.

## Prepare the report

For HTML reports, prefer a single `.html` file with inline CSS and JavaScript and
embedded images (data URLs or inline SVG). `upload` accepts regular files, not
directories, and uploads each file separately; it does not preserve a website's
directory structure or rewrite relative asset links. If assets must be separate,
upload them first and use their returned absolute URLs in the HTML.

Finish and check the local report before uploading it. Give it a descriptive
filename, since that name appears in the published URL.

## Publish

The command requires `ZIPLINE_URL` and `ZIPLINE_TOKEN` in its environment. Check
that they are available without printing their values:

```sh
command -v upload >/dev/null &&
  test -n "${ZIPLINE_URL:-}" &&
  test -n "${ZIPLINE_TOKEN:-}"
```

If the command or configuration is missing, keep the finished artifact locally
and explain what is missing. The token belongs in the machine's environment,
never in the report, skill, or command arguments.

Upload one file or several files using quoted paths:

```sh
upload "/absolute/path/to/report.html"
upload "/absolute/path/to/report.html" "/absolute/path/to/appendix.pdf"
```

The script detects MIME types and prints one raw file URL per uploaded file to
stdout. Use those exact URLs. `ZIPLINE_FILE_URL`, when set, selects the file-serving
base URL; otherwise the script uses `ZIPLINE_URL`. `ZIPLINE_FOLDER_ID` optionally
selects the destination folder. Preserve the configured values.

Each invocation submits a new upload. If a request fails after it may have reached
the server, check its outcome before retrying to avoid duplicate uploads.

Check that the returned report URL is reachable with a browser or HTTP GET, then
return it as a Markdown link. If verification is unavailable, say the upload
returned a URL but could not be verified. If uploading fails, report the failure
and the local artifact path.
