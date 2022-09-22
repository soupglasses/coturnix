{ pkgs, nixgl }:
import ./extra-packages.nix { inherit pkgs; }
// import ./nixgl-packages.nix { inherit pkgs; inherit nixgl; }
