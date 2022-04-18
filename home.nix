{ pkgs, ... }:

{
  home.username = "sofi";
  home.homeDirectory = "/home/sofi";

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    initExtraBeforeCompInit = builtins.readFile ../configs/zsh/.zshrc;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home.packages = with pkgs; [
    comma
    niv
  ];

  home.stateVersion = "21.11";
}
