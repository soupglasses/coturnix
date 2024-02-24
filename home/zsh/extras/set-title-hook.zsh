#!/usr/bin/env zsh

autoload -Uz add-zsh-hook

function info_print () {
    local esc_begin esc_end
    esc_begin="$1"
    esc_end="$2"
    shift 2
    printf '%s' ${esc_begin}
    printf '%s' "$*"
    printf '%s' "${esc_end}"
}

function set_title () {
    info_print  $'\e]0;' $'\a' "$@"
}

function set_title_precmd () {
    set_title ${(%):-"%(4~|%-1~/…/%2~|%3~)"}
}

function set_title_preexec () {
    set_title "${(%):-}" "$2"
}

if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd set_title_precmd
	add-zsh-hook -Uz preexec set_title_preexec
fi
