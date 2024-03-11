#!/usr/bin/env zsh
# SPDX-FileCopyrightText: 2024 github.com/soupglasses <sofi+git@mailbox.org>
# SPDX-License-Identifier: ISC

##########################################################################
# ISC License
#
# Copyright (c) 2024 github.com/soupglasses <sofi+git@mailbox.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
##########################################################################

function edit {
    local toggle="$1"
    if [[ ! -z "$1" ]] && shift

    local args=""
    if [[ "$toggle" != -* ]]; then # If we don't set a toggle, assume query.
        args+="$toggle "
        toggle="--query"
    fi
    for arg in "$@"; do
        args+="$(printf "%q" "$arg") "
    done
    args="$(echo "$args" | awk '{$1=$1;print}')"

    local search_root
    search_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -z "$search_root" ]]; then
        search_root=$(pwd)
    fi

    pushd "$search_root" >/dev/null || return

    local my_file
    case "$toggle" in
        --help | -h)
            echo "Usage: edit [PATTERN] | edit [--filter, -f] [PATTERN] | edit [--query, -q] [PATTERN]"
            popd >/dev/null
            return 1
            ;;
        --filter | -f)
            if [[ -z "$args" ]]; then
                echo "Missing pattern."
                popd >/dev/null
                return 1
            fi
            my_file=$(fzf --filter "$args" | head -n1)
            ;;
        --query | -q)
            my_file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --select-1 --exit-0 --query "$args" | head -n1)
           ;;
        *)
            if [[ -n "$toggle" ]]; then echo "Unknown argument: $toggle"; fi
            popd >/dev/null
            return 1
            ;;
    esac

    if [[ -z "$my_file" ]]; then
        echo "No file selected, exiting..."
        popd >/dev/null
        return 1
    fi

    $EDITOR "$my_file"
    popd >/dev/null
}

function e {
    edit --filter "$@"
}
