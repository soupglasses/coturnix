{
  description = "Coturnix: My personal computer setup";

  nixConfig.allow-import-from-derivation = true; # NOTE: Only allow when `patches` is used.

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Utilities
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Formatting
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Utils
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
    treefmt-nix,
    devshell,
    ...
  }: let
    # List of each system-architecture we want to support for our packages and
    # development shells. Does not relate to our NixOS configurations
    # own architectures.
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    eachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          inherit system;
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    nixosConfigurations = {
      desktop = self.lib.mkSystem self {
        system = "x86_64-linux";
        overlays = builtins.attrValues self.overlays;
        modules = [
          self.nixosModules.computer
          ./nixos/hosts/desktop
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

    packages = eachSystem ({pkgs, ...}: import ./nixos/packages {inherit pkgs;});

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

    # -- Formatter --
    # Abstracts all formatting tools into one command, `nix fmt`.

    formatter = eachSystem ({pkgs, ...}:
      treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs.alejandra.enable = true;
        programs.deadnix.enable = true;
        programs.terraform.enable = true;
      });

    # -- Development Shells --
    # Virtual shells with packages and shell hooks aiding development.

    devShells = eachSystem ({
      system,
      pkgs,
    }: {
      default = devshell.legacyPackages.${system}.mkShell {
        devshell = {
          startup = {
            motd = nixpkgs.lib.mkForce {text = "";};
            pre-commit = {text = self.checks.${system}.pre-commit.shellHook;};
          };
          packages = with pkgs; [
            nixUnstable
            nixos-rebuild
            # Formatters
            alejandra
            deadnix
          ];
        };
      };
    });

    # -- Tests --
    # Tests verifying configurations and commits are correct.

    checks = eachSystem ({
      system,
      pkgs,
    }: {
      pre-commit = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        excludes = ["-deps.nix$" "-composition.nix$" ".patch$"];
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          editorconfig-checker.enable = true;
          codespell = {
            enable = true;
            name = "codespell";
            language = "system";
            entry = "${pkgs.codespell}/bin/codespell -L anull -- ";
            types = ["text"];
          };
        };
      };
    });
  };
}
