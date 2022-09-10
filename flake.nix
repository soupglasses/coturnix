{
  description = "Coturnix: My personal computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-nightly.url = "github:imsofi/nixpkgs/pr/hunspell-dicts/norwegian";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    chrome-pwa.url = "github:Luis-Hebendanz/nixos-chrome-pwa";
  };

  outputs = inputs@{ self, nixpkgs, nur, nix-index-database, chrome-pwa, ... }:
  let
    allSystems = [ "x86_64-linux" "aarch64-linux" ];

    forSystems = systems: f: nixpkgs.lib.genAttrs systems 
      (system: f { inherit system; pkgs = nixpkgs.legacyPackages.${system}; });

    forAllSystems = f: forSystems allSystems f;

    commonModule = {
      # Helps error message know where this module is defined, avoiding `<unknown-file>` in errors.
      _file = ./flake.nix;
      config = {
        nixpkgs.overlays = [
          nur.overlay
        ] ++ (nixpkgs.lib.attrValues self.overlays);
      };
    };
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
            ] ++ (nixpkgs.lib.attrValues self.overlays);
            nixpkgs.config.packageOverrides = pkgs: { wine = (pkgs.winePackagesFor "wineWow").full; };
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "nvidia-x11"
              "nvidia-settings"
              "nvidia-patch"
              "steam"
              "steam-original"
              "steam-runtime"
              "spotify"
              "spotify-unwrapped"
            ];
          }
          chrome-pwa.nixosModule
          ./hosts/desktop
       ];
      };
    };
    devShell = forAllSystems
      ({ pkgs, ... }:
        pkgs.mkShell {
          buildInputs = with pkgs; [
            codespell
            nixpkgs-fmt
            nixUnstable
          ];
        }
      );
  };
}
