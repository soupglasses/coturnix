{ pkgs, ... }:
{
  home.packages = [ pkgs.grc ];

  programs.zsh.initExtra = ''
    source ${./zsh-files/grc.zsh}
  '';
}
