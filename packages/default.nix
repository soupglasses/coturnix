{pkgs}: {
  genpatch = pkgs.callPackage ./genpatch {};
  nvim = pkgs.callPackage ./neovim {};
  ps3iso-utils = pkgs.callPackage ./ps3iso-utils {};
  steinwurf-tasker = pkgs.python3Packages.callPackage ./steinwurf-tasker {};
  tas2563-fw = pkgs.callPackage ./tas2563-fw {};
}
