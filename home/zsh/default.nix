{lib, ...}: {
  imports = [
    ./history.nix
    ./modules/grc
  ];

  # Integrations
  programs.starship.enableZshIntegration = true; # Fancy pants prompt.
  programs.atuin.enableZshIntegration = true; # For shared history and CTRL-R.
  programs.fzf.enableZshIntegration = true; # For Fuzzy find CTRL-T and ALT-C.
  services.gpg-agent.enableZshIntegration = true;
  programs.dircolors.enable = true;
  programs.command-not-found.enable = false;
  programs.zoxide.enable = true; # For `z` support. TODO: Might fit better elsewhere.

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
      # Allow quick editing of files with edit, e(dit), e(edit)i(nterative).
      source ${./extras/edit.zsh}
      # Dynamic window title that changes on directory/command.
      source ${./extras/set-title-hook.zsh}
      # Custom options for zsh-syntax-highlight.
      source ${./extras/zsh-highlight.zsh}

      # Expose custom functions.
      autoload mkdircd l edit e ei
    '';
    plugins = [
      {
        name = "functions";
        src = ./functions;
      }
    ];
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  };
}
