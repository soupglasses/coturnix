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
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  home.sessionVariablesExtra = ''
    export NIX_PATH="${NIX_PATH}''${NIX_PATH:+:}$NIX_PATH"
  '';
}
