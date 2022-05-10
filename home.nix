{ pkgs, inputs, ... }:
{
  imports = [
    # Setup
    ./modules/nix-settings.nix
    # Configure
    ./modules/terminal
    # Tools
    ./modules/tools/comma.nix
    ./modules/tools/git.nix
  ];

  # To manage `.profile` for session variables.
  programs.bash = {
    enable = true;
    profileExtra = ''
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
    '';
  };

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
    glow
    # Gui
    apache-directory-studio
  ];

  home.stateVersion = "21.11";
}
