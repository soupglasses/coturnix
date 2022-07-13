{
  description = "Coturnix: My personal computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
  };

  outputs = inputs@{ self, nixpkgs, nur, home-manager, nix-index-database, ... }:
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
        home-manager.sharedModules = [
          ({ config, pkgs, ...}:
            let inherit (pkgs.stdenv) hostPlatform; in
            {
              config = nixpkgs.lib.mkIf config.programs.nix-index.enable {
                home.file."${config.xdg.cacheHome}/nix-index/files".source =
                  nix-index-database.legacyPackages.${hostPlatform.system}.database 
                    or nix-index-database.legacyPackages."x86_64-${hostPlatform.parsed.kernel.name}".database;
              };
            })
        ];
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
              "steam"
              "steam-original"
              "steam-runtime"
              "spotify"
              "spotify-unwrapped"
            ];
          }
          ./hosts/desktop
          ./hardware/desktop
          #home-manager.nixosModules.home-manager {
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #  home-manager.extraSpecialArgs = { inherit system inputs; };
          #  home-manager.users."sofi" = {
          #    imports = [
          #      ./home
          #    ];
          #  };
          #}
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
