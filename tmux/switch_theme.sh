#!/bin/bash

TMUX_CONF=$(readlink -f "$HOME/.tmux.conf")

PLACEHOLDER="SOME_RANDOM_STRING"

THEME1="set -g @catppuccin_flavour 'latte'"
THEME2="set -g @catppuccin_flavour 'mocha'"

sed -i '' "s/$THEME1/$PLACEHOLDER/g" $TMUX_CONF
sed -i '' "s/$THEME2/$THEME1/g" $TMUX_CONF
sed -i '' "s/$PLACEHOLDER/$THEME2/g" $TMUX_CONF

tmux source-file $TMUX_CONF
