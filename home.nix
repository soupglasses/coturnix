{ lib, pkgs, config, ... }:
{
  imports = [
    # Setup
    ./modules/nix-settings.nix
    ./modules/generic-linux
    # Configure
    ./modules/terminal
    # Tools
    ./modules/tools/comma.nix
    ./modules/tools/elixir.nix
    ./modules/tools/git.nix
    ./modules/tools/gpg.nix
    ./modules/tools/navi
    # Gui
    ./modules/gnome
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    # Requirements
    home-manager
    # Cli
    asciinema
    ferium
    glow
    tealdeer
    tree
    trash-cli
    gh
    sd
    dig
    ripgrep
    rsync
    moreutils  # vidir, etc.
    kubectl
    # Gui
    dino
    geogebra
    # Neovim
    sumneko-lua-language-server
    rnix-lsp
    pyright
  ] ++ (if config.targets.genericLinux.enable then [
    nixgld.kitty
    nixgl.nixGLIntel
  ] else [
    kitty
    signal-desktop
    prismlauncher
  ]);

  home.stateVersion = "21.11";
}
