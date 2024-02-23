#!/usr/bin/env zsh

## Allow copy/paste on both xorg and wayland.
function copy {
    if [ $XDG_SESSION_TYPE = 'x11' ]; then
        xclip -selection clipboard
    else
        wl-copy
    fi
}

function paste {
    if [ $XDG_SESSION_TYPE = 'x11' ]; then
        xclip -out -selection clipboard
    else
        wl-paste
    fi
}
