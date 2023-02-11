{config, lib, ...}:
{
  config = lib.mkIf (config.programs.git.enable) {
    home.sessionVariablesExtra = ''
      # WORKAROUND: https://github.com/NixOS/nixpkgs/issues/160527
      export GIT_SSH="/usr/bin/ssh"
    '';
  };
}
