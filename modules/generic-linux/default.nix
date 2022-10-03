{ lib, pkgs, ... }:
{
  imports = [
    ./env.nix
    ./nixgl.nix
    ./git.nix
  ];

  # Allow nix to deal with system paths outside of nix when managed by home-manager.
  targets.genericLinux.enable = true;

  # Allow nix to configure `.profile` to let session variables be configured by nix.
  programs.bash.enable = true;

  programs.bash.profileExtra = ''
    # WORKAROUND: https://github.com/nix-community/home-manager/issues/1439
    export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
  '';
}
