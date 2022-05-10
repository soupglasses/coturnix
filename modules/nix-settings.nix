{ pkgs, inputs, ... }:
{
  nix = {
    enable = true;
    package = pkgs.nixUnstable;
    registry = {
      nixpkgs = {
        from = { id = "nixpkgs"; type = "indirect"; };
        flake = inputs.nixpkgs;
      };
      home-manager = {
        from = { id = "home-manager"; type = "indirect"; };
        flake = inputs.home-manager;
      };
    };
    checkConfig = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };
}
