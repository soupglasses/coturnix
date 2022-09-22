{ pkgs, lib, ... }:
{
  imports = [
    ./history.nix

    ./plugins/fasd
    ./plugins/grc
  ];

  # Integrations
  programs.starship.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
  services.gpg-agent.enableZshIntegration = true;
  programs.dircolors.enable = true;
  programs.nix-index.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    prezto.enable = lib.mkForce false;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "emacs";
    initExtraFirst = ''
      unsetopt AUTOCD
      unsetopt BEEP
      unsetopt EXTENDEDGLOB

      # Customized zsh prompt.
      source ${./extras/prompt.zsh}
    '';
    initExtraBeforeCompInit = ''
      # Case insensitive path-completion.
      source ${./extras/comp-init/case-insensitive-search.zsh}
      # Colored tab completion.
      source ${./extras/comp-init/colored-tab-complete.zsh}
    '';
    initExtra = ''
      # Run ls after every cd command.
      source ${./extras/autols.zsh}
      # Window-system independent copy/paste functions.
      source ${./extras/copypaste.zsh}
      # Dynamic window title that changes on directory/command.
      source ${./extras/set-title-hook.zsh}
      # Custom options for zsh-syntax-highlight.
      source ${./extras/zsh-highlight.zsh}
    '';
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." =  "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  }; 
}
