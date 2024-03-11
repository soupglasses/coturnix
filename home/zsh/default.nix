{lib, ...}: {
  imports = [
    ./history.nix
    ./modules/grc
  ];

  # History
  programs.atuin.enableZshIntegration = true; # For shared history and CTRL-R.
  programs.atuin.flags = ["--disable-up-arrow"]; # Use our own custom implementation.

  # Integrations
  programs.starship.enableZshIntegration = true; # Fancy pants prompt.
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
      # Custom implementation of up-search to use atuin's database.
      source ${./extras/atuin-up-arrow.zsh}
      # Run ls after every cd command.
      source ${./extras/autols.zsh}
      # Window-system independent copy/paste functions.
      source ${./extras/copypaste.zsh}
      # Allow quick editing of files with edit, e(dit), e(edit)i(nterative).
      source ${./extras/edit.zsh}
      # Replace multiple dots (...) to path (../..) automatically.
      source ${./extras/replace-multiple-dots.zsh}
      # Dynamic window title that changes on directory/command.
      source ${./extras/set-title-hook.zsh}
      # Custom options for zsh-syntax-highlight.
      source ${./extras/zsh-highlight.zsh}

      # Expose custom functions.
      autoload mkdircd l edit e
    '';
    plugins = [
      {
        name = "functions";
        src = ./functions;
      }
    ];
  };
}
