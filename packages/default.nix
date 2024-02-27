{pkgs}: {
  genpatch = pkgs.callPackage ./genpatch {};
  nvim = pkgs.callPackage ./neovim {};
  ps3iso-utils = pkgs.callPackage ./ps3iso-utils {};
  tas2563-fw = pkgs.callPackage ./tas2563-fw {};
}
