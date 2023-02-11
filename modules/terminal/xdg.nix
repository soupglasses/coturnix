{lib, ...}:{
  xdg.enable = true;

  home.sessionVariables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };

  # Zsh config, plugins, history.
  programs.zsh.dotDir = ".config/zsh";
  programs.zsh.history.path = "$ZDOTDIR/.zsh_history";
  home.file.".zshenv".enable = false;
}
