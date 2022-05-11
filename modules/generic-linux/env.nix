{ config, lib, pkgs, ... }:
let
  initText = ''
    # WORKAROUND: https://github.com/nix-community/home-manager/issues/2751
    export EDITOR="$VISUAL"
  '';
in
{
  programs.bash.initExtra = initText;
  programs.zsh.initExtraFirst = initText;
}
