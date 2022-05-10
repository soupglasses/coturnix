{ pkgs, ... }:
{
  imports = [
    ./history.nix

    ./plugins/fasd
    ./plugins/grc
  ];

  # Integrations
  programs.starship.enableZshIntegration = true;
  programs.dircolors.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraFirst = ''
      unsetopt AUTOCD
      unsetopt BEEP
      unsetopt EXTENDEDGLOB

      # Simple customized zsh prompt.
      source ${./extras/prompt.zsh}
    '';
    initExtra = ''
      # Run ls after every cd command.
      source ${./extras/autols.zsh}
      # Window-system independent copy/paste functions.
      source ${./extras/copypaste.zsh}
      # Dynamic window title that changes on directory/command.
      source ${./extras/xterm-title-hook.zsh}
    '';
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." =  "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  }; 
}
