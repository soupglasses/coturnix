{ config, lib, pkgs, ... }:
let
  initText = ''
    # WORKAROUND: https://github.com/nix-community/home-manager/issues/2751
    export EDITOR="$VISUAL"

    # Add user installed software to PATH.
    export PATH="${config.home.homeDirectory}/.local/bin:$PATH"

    # WORKAROUND: https://github.com/guibou/nixGL/issues/116
    # Use system libva/libgl/ld by default over nix versions.
    unset LIBVA_DRIVERS_PATH LIBGL_DRIVERS_PATH LD_LIBRARY_PATH
  '';
in
{
  programs.bash.initExtra = initText;
  programs.zsh.initExtraFirst = initText;
}
