{ pkgs, ... }:
{
  home.packages = [ pkgs.grc ];

  programs.zsh.initExtra = ''
    # Add grc (generic colorizer) for extra colored commands.
    source ${./grc.zsh}
  '';
}
