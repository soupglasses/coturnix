{
  description = "Coturnix: My personal computer setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixexprs.url = "github:imsofi/nixexprs/update-nvidia-patch";
    nixexprs.inputs.nixpkgs.follows = "nixpkgs";
    #nix-gaming.url = "github:fufexan/nix-gaming";
    #nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    chrome-pwa.url = "github:Luis-Hebendanz/nixos-chrome-pwa";
  };

  outputs = inputs@{ self, nixpkgs, nur, nixexprs, nix-index-database, chrome-pwa, ... }:
  let

    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    #packages = forAllSystems (import ./pkgs);
    overlays = import ./overlays;
    nixosModules = import ./modules;

    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit system inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              nur.overlay
              nixexprs.overlays.arc
            ] ++ (nixpkgs.lib.attrValues self.overlays);
            nixpkgs.config.packageOverrides = pkgs: { wine = (pkgs.winePackagesFor "wineWow").full; };
            nixpkgs.config.allowUnfree = true;
          }
          chrome-pwa.nixosModule
          ./hosts/desktop
       ];
      };
    };
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system}.pkgs;
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          codespell
          nixpkgs-fmt
          nixUnstable
        ];
      };
    });
  };
}
