#!/usr/bin/env zsh

# check if fasd is installed
if (( ! ${+commands[fasd]} )); then
  return
fi

fasd_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fasd-init-cache"
if [[ "$commands[fasd]" -nt "$fasd_cache" || ! -s "$fasd_cache" ]]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install \
    zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

alias v='f -e "$EDITOR"'
alias o='a -e xdg-open'
