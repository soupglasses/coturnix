{ pkgs, inputs, ... }:
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
}
