{ pkgs, ... }:
{
  kitty = pkgs.callPackage ./nixgl/kitty { };
}
