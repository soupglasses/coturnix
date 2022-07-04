{ lib, pkgs, inputs, ... }:
{
  imports = [
    # Setup
    ./modules/nix-settings.nix
    ./modules/generic-linux
    # Configure
    ./modules/terminal
    # Tools
    ./modules/tools/comma.nix
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
    tree
    # Gui
    apache-directory-studio
    geogebra
    kitty # TODO
    # Games
    polymc
    # Social
    signal-desktop
  ];

  home.stateVersion = "21.11";
}
