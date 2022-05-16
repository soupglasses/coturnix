{ lib, pkgs, inputs, ... }:
let
  NIX_PATH = lib.concatStringsSep ":" [
    "nixpkgs=${inputs.nixpkgs}"
  ];
in
{
  nix = {
    enable = true;
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    checkConfig = true;
    settings = {
      extra-experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;

      builders-use-substitutes = true;
      extra-substituters = [
        "https://imsofi.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "imsofi.cachix.org-1:KsqZ5nGoUfMHwzCGFnmTLMukGp7Emlrz/OE9Izq/nEM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  home.sessionVariablesExtra = ''
    export NIX_PATH="${NIX_PATH}''${NIX_PATH:+:}$NIX_PATH"
  '';
}
