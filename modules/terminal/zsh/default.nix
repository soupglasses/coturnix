{ pkgs, ... }:
{
  imports = [
    ./history.nix
    ./grc.nix
  ];

  programs.starship.enableZshIntegration = true;

  # TODO: Fzf, Kitty, Fasd, Dircolors, Bat

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraFirst = ''
      unsetopt AUTOCD
      unsetopt BEEP
      unsetopt EXTENDEDGLOB

      # Simple customized zsh prompt.
      source ${./zsh-files/prompt.zsh}
      # TODO: Fully remove old configuration.
      source ${../../../../configs/zsh/.zshrc}
    '';
    initExtra = ''
      # Run ls after every cd command.
      source ${./zsh-files/autols.zsh}
      # Window-system independent copy/paste functions.
      source ${./zsh-files/copypaste.zsh}
      # Dynamic window title that changes on directory/command.
      source ${./zsh-files/xterm-title-hook.zsh}
    '';
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." =  "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  }; 
}
