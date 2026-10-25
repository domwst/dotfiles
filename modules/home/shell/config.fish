abbr -a hist 'history --show-time="%Y-%m-%d "'
abbr -a gco git checkout
abbr -a gcb git checkout -b
abbr -a gcmsg git commit -m
abbr -a gp git push
abbr -a gl git pull
abbr -a gst git status
abbr -a gm git merge
abbr -a gsta git stash
abbr -a gstp git stash pop
abbr -a gd git diff
abbr -a ga git add
abbr -a gsu git submodule update
abbr -a gwt git worktree
abbr -a k kubectl
abbr -a py python3
abbr -a fzfb fzf --preview="bat --color=always {}"
abbr -a zel zellij

function ls
    eza $argv
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

abbr -a dotdot --regex '^\.\.+$' --function multicd

set -gx EDITOR nvim

set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

if type -q brew
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end

if type -q starship
    starship init fish | source

    # Result line of the command that just finished (the `result` profile in starship.toml).
    # Rendered once here and shown as the prompt's first line; fish_postexec doesn't fire for
    # an empty Enter, so it isn't repeated
    set -e STARSHIP_RESULT # may be inherited from a parent shell
    function __starship_render_result --on-event fish_postexec
        set -l s $status $pipestatus
        set -l finished (date +%R)
        set -gx STARSHIP_RESULT (STARSHIP_FINISHED=$finished starship prompt --profile result \
            --status=$s[1] --pipestatus="$s[2..]" --cmd-duration=$CMD_DURATION --terminal-width=$COLUMNS | string collect)
    end

    # Transient prompt: after Enter the prompt collapses to the result line and its chevron
    set -g fish_transient_prompt 1
    function starship_transient_prompt_func
        if set -q STARSHIP_RESULT
            echo $STARSHIP_RESULT
            set -e STARSHIP_RESULT
        end
        starship module character $argv
    end
end

if type -q zoxide
    zoxide init fish --cmd cd | source
end

if type -q kubectl
    kubectl completion fish | source
end

function vi_mode_bindings
    fish_vi_key_bindings

    bind -M insert alt-left backward-word
    bind -M insert alt-b backward-word

    bind -M insert alt-right forward-word
    bind -M insert alt-f forward-word

    bind -M insert alt-backspace backward-kill-word
end

set keybindings vi_mode_bindings

if type -q fzf
    fzf --fish | source
    set keybindings $keybindings fzf_key_bindings
end

function fish_user_key_bindings
    for fn in $keybindings
        $fn
    end
end

set -q fzf_preview_dir_cmd; or set fzf_preview_dir_cmd 'eza --tree --color=always'
set -q fzf_preview_file_cmd; or set fzf_preview_file_cmd 'bat -n --color=always --line-range :500'
set -q fzf_fd_opts; or set fzf_fd_opts --hidden --strip-cwd-prefix --exclude .git
set -q fzf_history_time_format; or set fzf_history_time_format %Y-%m-%d

function fzfpid
    ps -ef | sed 1d | fzf | awk '{ print $2 }'
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
