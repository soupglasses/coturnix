{ pkgs, ... }:
{
  programs.starship.enable = true;

  xdg.configFile."starship.toml".source =
    ../../../configs/starship/.config/starship.toml;
}
