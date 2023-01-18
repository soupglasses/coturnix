{ config, pkgs, lib, ... }:
{
  nix = {
    enable = true;
    package = pkgs.nixUnstable;
    checkConfig = true;
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];

      trusted-users = [ "root" "@wheel" ];

      builders-use-substitutes = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
