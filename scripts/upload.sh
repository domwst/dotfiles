#!/usr/bin/env bash
set -euo pipefail

: "${ZIPLINE_URL:?set ZIPLINE_URL}"
: "${ZIPLINE_TOKEN:?set ZIPLINE_TOKEN}"

if (( $# == 0 )); then
    echo "usage: $(basename -- "$0") FILE..." >&2
    exit 2
fi

headers=(
    -H "Authorization: ${ZIPLINE_TOKEN}"
    -H "X-Zipline-URL-Layout: id-name"
)

if [[ -n ${ZIPLINE_FOLDER_ID:-} ]]; then
    headers+=(-H "X-Zipline-Folder: ${ZIPLINE_FOLDER_ID}")
fi

forms=()
for path in "$@"; do
    if [[ ! -f $path ]]; then
        printf 'not a regular file: %s\n' "$path" >&2
        exit 2
    fi

    mime=$(file --brief --mime-type -- "$path")
    forms+=(-F "file=@${path};type=${mime}")
done

response=$(
    curl --fail-with-body --silent --show-error \
        "${headers[@]}" \
        "${forms[@]}" \
        "${ZIPLINE_URL%/}/api/upload"
)

# ZIPLINE_FILE_URL may be a separate, cookie-less file-serving domain.
file_base=${ZIPLINE_FILE_URL:-$ZIPLINE_URL}

jq -r --arg base "${file_base%/}" \
    '.files[] | "\($base)/raw/\(.publicId | @uri)/\(.publicName | @uri)"' \
    <<<"$response"
