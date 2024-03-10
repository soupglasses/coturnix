#!/usr/bin/env zsh
# MIT License - Copyright (c) 2017 momo-lab

function replace_multiple_dots() {
  local dots=$LBUFFER[-3,-1]
  if [[ $dots =~ "^[ //\"']?\.\.$" ]]; then
    LBUFFER=$LBUFFER[1,-3]'../.'
  fi
  zle self-insert
}

zle -N replace_multiple_dots
bindkey "." replace_multiple_dots
