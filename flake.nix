{
  description = "Coturnix: My personal computer setup";

  nixConfig.allow-import-from-derivation = true; # Only allow when `patches` is used.
  nixConfig.extra-substituters = [
    "https://ezkea.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Extra packages
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

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
    aagl,
    nixpkgs-xr,
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
        overlays = [self.overlays.packages nixpkgs-xr.overlays.default];
        patches = [
          # nixos/monado: init (https://github.com/NixOS/nixpkgs/pull/245005)
          (builtins.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/245005.patch"; # BAD!
            sha256 = "080y11dwgrc6mvcr3bi6s9i7mzq4fwwhc4z5pba2519v8llqkqcq";
          })
          # onnxruntime: 1.15.1 -> 1.16.3 (https://github.com/NixOS/nixpkgs/pull/258392)
          # broken dependency for opencomposite-helper
          (builtins.fetchurl {
            url = "https://github.com/NixOS/nixpkgs/pull/258392.patch"; # BAD!
            sha256 = "1fz63nzrn8ipj0p729da1n5fpdcn9x3qjp2kw7zz5h6nl24g465p";
          })
          # compressFirmwareXz: fix symlink type check (https://github.com/NixOS/nixpkgs/pull/284487)
          (builtins.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/284487.patch";
            sha256 = "0dwlgqwbywyd30w72imm8imgq8xyf2f4w7ziy70zxw0dp1glppaf";
          })
          # makeModulesClosure: include /lib/firmware/edid (https://github.com/NixOS/nixpkgs/pull/279789)
          (builtins.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/279789.patch"; # BAD!
            sha256 = "0qqljjjs8kbiri01lr8l64i7142yxdvr7c3h52bzg23149g070gd";
          })
        ];
        unfreePackages = pkgs:
          with pkgs; [
            steam
            steamPackages.steam
            steam-run
            spotify
            unityhub
          ];
        modules = [
          aagl.nixosModules.default
          self.nixosModules.computer
          self.nixosModules.hardware-amd-gpu
          self.nixosModules.mixins-gaming
          self.nixosModules.mixins-smartcard
          self.nixosModules.extra-substituters
          ./nixos/hosts/desktop
        ];
      };
      yoga = self.lib.mkSystem self {
        system = "x86_64-linux";
        overlays = [self.overlays.packages];
        modules = [
          aagl.nixosModules.default
          self.nixosModules.computer
          self.nixosModules.kernel-patching
          self.nixosModules.hardware-lenovo-yoga-7-14ARB7
          self.nixosModules.mixins-gaming
          self.nixosModules.mixins-smartcard
          #self.nixosModules.extra-substituters
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

        hardware-amd-gpu = import ./nixos/hardware/amd/gpu.nix;
        hardware-nvidia-gpu = import ./nixos/hardware/nvidia/gpu.nix;
        hardware-lenovo-yoga-7-14ARB7 = import ./nixos/hardware/lenovo-yoga-7-14ARB7;

        mixins-gaming = import ./nixos/mixins/gaming.nix;
        mixins-smartcard = import ./nixos/mixins/smartcard.nix;

        extra-substituters = {
          nix.settings.substituters = [
            "https://ezkea.cachix.org"
            "https://nix-community.cachix.org"
          ];
          nix.settings.trusted-public-keys = [
            "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
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
      });

    # -- Development Shells --
    # Virtual shells with packages and shell hooks aiding development.

    devShells = eachSystem ({
      system,
      pkgs,
    }: {
      default = devshell.legacyPackages.${system}.mkShell {
        devshell = {
          startup.motd = nixpkgs.lib.mkForce {text = "";};
          startup.pre-commit.text = self.checks.${system}.pre-commit.shellHook;
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
            entry = "${pkgs.codespell}/bin/codespell -L anull -L statics -- ";
            types = ["text"];
          };
        };
      };
    });
  };
}
