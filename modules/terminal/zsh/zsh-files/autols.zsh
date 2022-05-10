#!/usr/bin/env zsh

## Make ls run after cd
function cd {
    builtin cd "$@" && ls
}
