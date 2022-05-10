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
    '';
    initExtra = ''
      source ${./zsh-files/autols.zsh}
      source ${./zsh-files/copypaste.zsh}
      source ${./zsh-files/prompt.zsh}
      source ${./zsh-files/xterm-title-hook.zsh}
      source ${../../../../configs/zsh/.zshrc}
    '';
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." =  "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  }; 
}
