if test -f ~/.local/fish/env.fish
    source ~/.local/fish/env.fish
end

if test -d ~/.local/bin
    fish_add_path ~/.local/bin
end
