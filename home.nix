{ pkgs, inputs, ... }:
{
  imports = [
    # Setup
    ./modules/nix-settings.nix
    # Tools
    ./modules/comma.nix
  ];

  programs.bash = {
    enable = true;
    profileExtra = ''
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    initExtra = builtins.readFile ../configs/zsh/.zshrc;
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
