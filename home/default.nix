{ lib, pkgs, config, ... }:
{
  imports = [
    #./generic-linux
    ./nix-settings.nix
    ./terminal/default.nix
    ./gnome.nix
  ];

  # Allow nix to configure `.profile` to let session variables be configured by nix.
  programs.bash.enable = true;

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
    nvim
  ] ++ lib.optionals config.targets.genericLinux.enable [
    nixgld.kitty
    nixgl.nixGLIntel
  ];

  home.stateVersion = "21.11";
}
