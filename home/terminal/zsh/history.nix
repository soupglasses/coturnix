{ pkgs, ... }:
{
  programs.zsh = {
    history = {
      extended = true;
      ignoreSpace = true;
      ignoreDups = true;
      save = 500000;
      size = 500000;
      share = true;
    };
    initExtra = ''
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
      bindkey "^[[A" up-line-or-search
      bindkey "^[[B" down-line-or-search
    '';
  };
}
