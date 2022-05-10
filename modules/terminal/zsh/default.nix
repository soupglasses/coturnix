{ pkgs, lib, ... }:
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
    prezto.enable = lib.mkForce false;
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraFirst = ''
      # WORKAROUND: https://github.com/nix-community/home-manager/issues/2751
      export EDITOR="$VISUAL";

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
