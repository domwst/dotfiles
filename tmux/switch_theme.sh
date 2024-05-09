#!/bin/bash

TMUX_CONF=$(readlink -f "$HOME/.tmux.conf")

PLACEHOLDER="SOME_RANDOM_STRING"

if [[ $(uname) = "Linux" ]]; then
  SED="sed -i"
else
  SED="sed -i ''"
fi

THEME1="set -g @catppuccin_flavour 'latte'"
THEME2="set -g @catppuccin_flavour 'mocha'"

$SED "s/$THEME1/$PLACEHOLDER/g" $TMUX_CONF
$SED "s/$THEME2/$THEME1/g" $TMUX_CONF
$SED "s/$PLACEHOLDER/$THEME2/g" $TMUX_CONF

tmux source-file $TMUX_CONF
