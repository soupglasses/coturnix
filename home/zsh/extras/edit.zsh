#!/usr/bin/env zsh

function edit {
    local search_root
    search_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -z "$search_root" ]]; then
        search_root=$(pwd)
    fi

    pushd "$search_root" >/dev/null || return

    local my_file
    if [[ "$1" == "filter" ]]; then
        shift # Remove the first argument "filter"
        my_file=$(fzf --filter "$@" | head -n1)
    elif [[ "$1" == "query" ]]; then
        shift # Remove the first argument "query"
        my_file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --select-1 --exit-0 --query "${@:-}" | head -n1)
    elif [[ $# -gt 0 ]]; then
        popd >/dev/null
        edit query $@
        return $?
    else
        echo "Usage: edit PATTERN | edit filter PATTERN | edit query PATTERN"
        popd >/dev/null
        return 1
    fi

    if [[ -z "$my_file" ]]; then
        popd >/dev/null
        return 1
    fi

    $EDITOR "$my_file"
    popd >/dev/null
}

function e {
    edit filter $@
}

function ei {
    edit query $@
}