#!/usr/bin/env zsh

export PROMPT='%F{blue}%(4~|%-1~/…/%2~|%3~)%f ${VIRTUAL_ENV:+"%F{magenta}env "}%(?..%F{red}E%? )%F{248}%#%f '
