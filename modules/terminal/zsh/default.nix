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
  services.gpg-agent.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    prezto.enable = lib.mkForce false;
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraFirst = ''
      unsetopt AUTOCD
      unsetopt BEEP
      unsetopt EXTENDEDGLOB

      # Customized zsh prompt.
      source ${./extras/prompt.zsh}
    '';
    initExtraBeforeCompInit = ''
      # Colored tab completion.
      source ${./extras/comp-init/colored-tab-complete.zsh}
      # Case insensitive path-completion.
      source ${./extras/comp-init/case-insensitive-search.zsh}
    '';
    initExtra = ''
      # Run ls after every cd command.
      source ${./extras/autols.zsh}
      # Window-system independent copy/paste functions.
      source ${./extras/copypaste.zsh}
      # Dynamic window title that changes on directory/command.
      source ${./extras/set-title-hook.zsh}
    '';
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." =  "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  }; 
}
