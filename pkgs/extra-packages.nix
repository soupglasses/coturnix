{ pkgs, ... }:
{
  nvim = import ./extras/neovim { inherit pkgs; };
  ps3iso-utils = pkgs.callPackage ./extras/ps3iso-utils { };
}
