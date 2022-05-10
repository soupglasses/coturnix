{ pkgs, inputs, ... }:
{
  imports = [
    ./modules/nix-settings.nix
  ];

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
    asciinema
    comma
    glow
    home-manager
  ];

  home.stateVersion = "21.11";
}
