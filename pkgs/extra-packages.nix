{ pkgs, ... }:
{
  adw-gtk3 = pkgs.callPackage ./extras/adw-gtk3 { };
  nvim = import ./extras/neovim { inherit pkgs; };
}
