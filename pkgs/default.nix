{ pkgs }:
{
  geogebra = pkgs.callPackage ./geogebra { };
  adw-gtk3 = pkgs.callPackage ./adw-gtk3 { };
}
