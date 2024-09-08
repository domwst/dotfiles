#!/usr/bin/env bash

if [[ $(uname) = "Linux" ]]; then
  NC="nc -q0"
else
  NC="nc"
fi

(cat "$@" | $NC localhost 12015) && exit
