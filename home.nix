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
    # Gui
    apache-directory-studio
  ];

  home.stateVersion = "21.11";
}
