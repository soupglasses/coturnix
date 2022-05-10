{ pkgs, ... }:
{
  home.packages = [ pkgs.fasd ];

  programs.zsh.initExtraBeforeCompInit = ''
    # Set up fasd for quick access to files and folders.
    source ${./fasd.zsh}
  '';
}
