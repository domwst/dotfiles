# Passes through only interactive ssh sessions
status is-interactive; or return
set -q SSH_TTY; or return
set -q SSH_CLIENT; or return

set -l AUTH_SOCK "$HOME/.ssh/auth.sock"
if test "$SSH_AUTH_SOCK" != "$AUTH_SOCK"; and test "$SSH_AUTH_SOCK" != ""
    ln -sf "$SSH_AUTH_SOCK" "$AUTH_SOCK"
    set -gx SSH_AUTH_SOCK "$AUTH_SOCK"
end
