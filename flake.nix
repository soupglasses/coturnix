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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    systems,
    home-manager,
    aagl,
    nixpkgs-xr,
    pre-commit-hooks,
    treefmt-nix,
    devshell,
    ...
  }: let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system:
        f {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [self.overlays.packages];
          };
        });
  in {
    # -- NixOS Configurations --
    # Holds the set of our NixOS configured computers.

    nixosConfigurations = {
      desktop = self.lib.mkSystem self {
        system = "x86_64-linux";
        overlays = [nixpkgs-xr.overlays.default];
        patches = [
          # nixos/monado: init (https://github.com/NixOS/nixpkgs/pull/245005)
          (builtins.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/245005.patch"; # BAD!
            sha256 = "1rq7qbfp8fr0vj4nkzj4czqjc0s1kk7bncin3am1sas8b1j9inrc";
          })
          # nixos/hardware.display: init module (https://github.com/NixOS/nixpkgs/pull/279789)
          (builtins.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/279789.patch"; # BAD!
            sha256 = "1frn7mq6121k8arjkzjxl53fd80f3d0f07s6gfbrdxfihbz8gx7c";
          })
        ];
        unfreePackages = [
          "obsidian"
          "steam"
          "steam-original"
          "steam-run"
          "spotify"
          "unityhub"
        ];
        insecurePackages = [
          "electron"
        ];
        modules = [
          aagl.nixosModules.default
          self.nixosModules.base-computer
          self.nixosModules.hardware-amd-gpu
          self.nixosModules.mixins-gaming
          self.nixosModules.mixins-smartcard
          self.nixosModules.extra-substituters
          ./hosts/desktop
        ];
      };
      yoga = self.lib.mkSystem self {
        system = "x86_64-linux";
        unfreePackages = [
          "obsidian"
          "steam"
          "steam-original"
          "steam-run"
          "spotify"
        ];
        insecurePackages = [
          "electron"
        ];
        modules = [
          aagl.nixosModules.default
          self.nixosModules.base-computer
          self.nixosModules.kernel-patching
          self.nixosModules.hardware-lenovo-yoga-7-14ARB7
          self.nixosModules.mixins-gaming
          self.nixosModules.mixins-smartcard
          self.nixosModules.extra-substituters
          ./hosts/yoga
        ];
      };
    };

    # -- Home Configurations --
    # Holds user-spessific dotfile configuration.

    legacyPackages = eachSystem ({pkgs, ...}: {
      homeConfigurations = pkgs.lib.recurseIntoAttrs {
        sofi = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home
            rec {
              home.username = "sofi";
              home.homeDirectory = "/home/${home.username}";
            }
          ];
        };
      };
    });

    # -- NixOS Modules --
    # Modules create or modify configurable options included in a full nixos configuration.

    nixosModules =
      {
        base-generic = import ./base/generic;
        base-computer = import ./base/computer;

        hardware-amd-gpu = import ./hardware/amd/gpu.nix;
        hardware-nvidia-gpu = import ./hardware/nvidia/gpu.nix;
        hardware-lenovo-yoga-7-14ARB7 = import ./hardware/lenovo-yoga-7-14ARB7;

        mixins-gaming = import ./mixins/gaming.nix;
        mixins-smartcard = import ./mixins/smartcard.nix;

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
      // import ./modules;

    # -- Packages --
    # Exposes derivations as top level packages so others can use them.

    packages = eachSystem ({pkgs, ...}: import ./packages {inherit pkgs;});

    # -- Library --
    # Holds our various functions and derivations aiding in deploying nixos.

    lib = import ./lib {inherit (nixpkgs) lib;};

    # -- Overlays --
    # Allows modification of nixpkgs in-place, adding and modifying its functionality.

    overlays =
      import ./overlays
      // {
        packages = final: _prev: {
          coturnix =
            final.lib.recurseIntoAttrs
            (import ./packages {inherit (final) pkgs;});
        };
      };

    # -- Formatter --
    # Abstracts all formatting tools into one command, `nix fmt <location>`.

    formatter = eachSystem ({pkgs, ...}:
      treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs.alejandra.enable = true;
        programs.deadnix.enable = true;
      });

    # -- Development Shells --
    # Scoped environments including packages and shell-hooks to aid project development.

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
            pkgs.home-manager
            # Formatters
            alejandra
            deadnix
          ];
        };
      };
    });

    # -- Tests --
    # Verify locally that our nix configurations and file formatting is correct.

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
