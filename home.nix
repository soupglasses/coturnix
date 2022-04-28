{ pkgs, ... }:

{
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

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home.packages = with pkgs; [
    comma
    niv
  ];

  home.stateVersion = "21.11";
}
