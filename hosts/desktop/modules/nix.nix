{ config, pkgs, lib, ... }:
{
  nix = {
    enable = true;
    package = pkgs.nixUnstable;
    checkConfig = true;
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];

      builders-use-substitutes = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://imsofi.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "imsofi.cachix.org-1:KsqZ5nGoUfMHwzCGFnmTLMukGp7Emlrz/OE9Izq/nEM="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };
}
