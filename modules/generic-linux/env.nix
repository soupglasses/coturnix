{ config, lib, pkgs, ... }:
let
  initText = ''
    # WORKAROUND: https://github.com/nix-community/home-manager/issues/2751
    export EDITOR="$VISUAL"
    # GENERIC_LINUX: Add user installed software
    export PATH="${config.home.homeDirectory}/.local/bin:$PATH"
  '';
in
{
  programs.bash.initExtra = initText;
  programs.zsh.initExtraFirst = initText;
}
