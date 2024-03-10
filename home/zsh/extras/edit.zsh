#!/usr/bin/env zsh

function edit {
    local search_root
    search_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -z "$search_root" ]]; then
        search_root=$(pwd)
    fi

    pushd "$search_root" >/dev/null || return

    local my_file
    if [[ "$1" == "--filter" || "$1" == "-f" ]]; then
        shift # Remove the first argument "filter"
        my_file=$(fzf --filter "$@" | head -n1)
    elif [[ "$1" == "--query" || "$1" == "-q" ]]; then
        shift # Remove the first argument "query"
        my_file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --select-1 --exit-0 --query "${@:-}" | head -n1)
    elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: edit [PATTERN] | edit [--filter, -f] [PATTERN] | edit [--query, -q] [PATTERN]"
        popd >/dev/null
        return 1
    else
        popd >/dev/null
        edit --query $@
        return $?
    fi

    if [[ -z "$my_file" ]]; then
        popd >/dev/null
        return 1
    fi

    $EDITOR "$my_file"
    popd >/dev/null
}

function e {
    edit --filter $@
}

function ei {
    edit --query $@
}
