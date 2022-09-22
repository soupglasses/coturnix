{ pkgs, nixgl }:
{
  kitty = pkgs.callPackage ./nixgl/kitty { inherit nixgl; };
}
