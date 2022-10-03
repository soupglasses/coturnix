{ config, lib, pkgs, ... }:
let
  initText = ''
    # WORKAROUND: https://github.com/guibou/nixGL/issues/116
    # Use system libva/libgl/ld by default over nix versions.
    unset LIBVA_DRIVERS_PATH LIBGL_DRIVERS_PATH LD_LIBRARY_PATH __EGL_VENDOR_LIBRARY_FILENAMES
  '';
in
{
  programs.zsh.initExtraFirst = initText;
}
