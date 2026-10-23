set -eu

{
    printf '\033]52;c;'
    base64 | tr -d '\r\n'
    printf '\007'
} >/dev/tty
