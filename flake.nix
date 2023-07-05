{
  description = "Coturnix: My personal computer setup";

  nixConfig.allow-import-from-derivation = true; # NOTE: Only allow when `patches` is used.

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";

    # Utilities
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Formatting
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
    treefmt-nix,
    ...
  }: let
    # List of each system-architecture we want to support for our packages and
    # development shells. Does not relate to our NixOS configurations
    # own architectures.
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    # Recursively joins together sets using "${system}" down to one common set.
    # This makes supporting multiple system-architectures easy.
    foldEachSystem = systems: f:
      builtins.foldl' nixpkgs.lib.recursiveUpdate {}
      (nixpkgs.lib.forEach systems f);
  in
    foldEachSystem supportedSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        desktop = self.lib.mkSystem self {
          system = "x86_64-linux";
          overlays = builtins.attrValues self.overlays;
          modules = [
            self.nixosModules.computer
            ./nixos/hosts/desktop
          ];
          patches = [
            # "linuxPackages.nvidiaPackages.mkDriver: init" https://github.com/NixOS/nixpkgs/pull/240075
            (builtins.fetchurl {
              url = "https://github.com/NixOS/nixpkgs/commit/8ef3c5b70e8aac987594dde103da016915e0d6a8.patch";
              sha256 = "16j4irxy7kq09g7gf0n9ccjapcxxiyz15g5z88fr3zybws7i8vyy";
            })
          ];
        };
        yoga = self.lib.mkSystem self {
          system = "x86_64-linux";
          overlays = builtins.attrValues self.overlays;
          modules = [
            self.nixosModules.computer
            self.nixosModules.kernel-patching
            self.nixosModules.hardware-lenovo-yoga-7-14ARB7
            ./nixos/hosts/yoga
          ];
        };
      };

      # -- NixOS Modules --
      # Modules define or change a set of options included in a full system configuration.

      nixosModules =
        {
          common = import ./nixos/common;
          computer = import ./nixos/computer;

          hardware-lenovo-yoga-7-14ARB7 = import ./nixos/hardware/lenovo-yoga-7-14ARB7 {};
        }
        // import ./nixos/modules;

      # -- Packages --
      # Our own set of packages.

      packages.${system} = import ./nixos/packages {inherit pkgs;};

      # -- Library --
      # Set of common functions to be used around the flake.

      lib = import ./nixos/lib {inherit (nixpkgs) lib;};

      # -- Overlays --
      # Allows modification of nixpkgs in place to add and modify its functionality.

      overlays =
        import ./nixos/overlays
        // {
          packages = final: _prev: {
            coturnix =
              final.lib.recurseIntoAttrs
              (import ./nixos/packages {inherit (final) pkgs;});
          };
        };

      # -- Development Shells --
      # Virtual shells with packages and shell hooks aiding development.

      devShells.${system}.default = pkgs.mkShellNoCC {
        shellHook = self.checks.${system}.pre-commit-hooks.shellHook;
        packages = with pkgs; [
          # Basic Packages
          nixFlakes
          nixos-rebuild
          # Helpers and formatters
          alejandra
          deadnix
          statix
        ];
      };

      # -- Formatter --

      formatter.${system} = treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs.alejandra.enable = true;
        settings.formatter.deadnix = {
          command = "${pkgs.deadnix}/bin/deadnix";
          options = ["--edit"];
          includes = ["*.nix"];
        };
      };

      # -- Tests --
      # Tests verifying configurations and commits are correct.

      checks.${system} = {
        pre-commit-hooks = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # alejandra.enable = true;
            # deadnix.enable = true;
            # codespell = {
            #   enable = true;
            #   name = "codespell";
            #   language = "system";
            #   entry = "${pkgs.codespell}/bin/codespell";
            #   types = ["text"];
            # };
          };
        };
      };
    });
}
