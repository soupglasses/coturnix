{ pkgs, ... }:
{
  adw-gtk3 = pkgs.callPackage ./extras/adw-gtk3 { };
  nvim = import ./extras/neovim { inherit pkgs; };
  ps3iso-utils = pkgs.callPackage ./extras/ps3iso-utils { };
  ns-usbloader = pkgs.callPackage ./extras/ns-usbloader { };
}
