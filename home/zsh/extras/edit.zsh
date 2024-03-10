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
