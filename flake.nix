{
  description = "Coturnix: My personal computer setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nur, home-manager, ... }:
  let
    system = "x86_64-linux";

    forSystems = systems: f: nixpkgs.lib.genAttrs systems 
      (system: f { inherit system; pkgs = mkPkgs nixpkgs system; });

    allSystems = [ "x86_64-linux" "aarch64-linux" ];

    forAllSystems = f: forSystems allSystems f;

    mkPkgs = pkgs: system: extraOptions:
      import pkgs {
        inherit system;
        overlays = [
          nur.overlay 
        ] ++ (nixpkgs.lib.attrValues self.overlays);
      };
  in {
    #packages = forAllSystems (import ./pkgs);
    overlays = import ./overlays;
    nixosModules = import ./modules;

    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              nur.overlay
            ] ++ (nixpkgs.lib.attrValues self.overlays);
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
    devShell = nixpkgs.pkgs.mkShell {
      buildInputs = with nixpkgs.pkgs; [
        codespell
        nixpkgs-fmt
        nixUnstable
      ];
    };
  };
}
