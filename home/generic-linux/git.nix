{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.programs.git.enable) {
    home.sessionVariablesExtra = ''
      # WORKAROUND: https://github.com/NixOS/nixpkgs/issues/160527
      export GIT_SSH="/usr/bin/ssh"
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    '';
  };
}
