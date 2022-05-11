{ config, lib, pkgs, ... }:
let
  initText = ''
    # WORKAROUND: https://github.com/NixOS/nixpkgs/issues/160527
    export GIT_SSH="/usr/bin/ssh"
  '';
in
{
  config = lib.mkIf (config.programs.git.enable) {
    programs.bash.initExtra = initText;
    programs.zsh.initExtraFirst = initText;
  };
}
