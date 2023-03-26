{
  description = "Coturnix: My personal computer setup";

  nixConfig.allow-import-from-derivation = false; # Disable building at evaluation time.

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-22.11";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

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
    nixos-generators,
    pre-commit-hooks,
    treefmt-nix,
    ...
  } @ inputs: let
    # List of each system-architecture we want to support for our packages and
    # development shells. Does not relate to our NixOS configurations
    # own architectures.
    supportedSystems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
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
          modules = [
            self.nixosModules.computer
            ./nixos/hosts/desktop
          ];
        };
        yoga = self.lib.mkSystem self {
          system = "x86_64-linux";
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

      nixosModules = {
        common = import ./nixos/common;
        computer = import ./nixos/computer;

        hardware-lenovo-yoga-7-14ARB7 = import ./nixos/hardware/lenovo-yoga-7-14ARB7 {};
      } // import ./nixos/modules;

      # -- Packages --
      # Our own set of packages.

      packages.${system} = import ./nixos/packages {inherit pkgs;} // {
        install-iso-yoga-7-14arb7 = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays; }
            self.nixosModules.computer
            self.nixosModules.kernel-patching
            self.nixosModules.hardware-lenovo-yoga-7-14ARB7
            ({config, pkgs, ...}: {
              services.xserver.enable = true;
              services.xserver.desktopManager.gnome.enable = true;
              services.xserver.displayManager.gdm = {
                enable = true;
                wayland =
                  if (builtins.elem "nvidia" config.services.xserver.videoDrivers)
                  then false
                  else true;
              };

              environment.systemPackages = with pkgs.gnomeExtensions; [
                appindicator
                impatience
              ];

              services.dbus.enable = true;
              services.udev.packages = [pkgs.gnome.gnome-settings-daemon];

              hardware.pulseaudio.enable = false;

              services.pipewire.enable = true;
              services.pipewire.pulse.enable = true;
              services.pipewire.wireplumber.enable = true;
              services.pipewire.media-session.enable = false;
              services.pipewire.alsa.support32Bit = true;
              services.pipewire.alsa.enable = true;
            })
          ];
          format = "install-iso";
        };
      };


      # -- Library --
      # Set of common functions to be used around the flake.

      lib = import ./nixos/lib {inherit (nixpkgs) lib;};

      # -- Overlays --
      # Allows modification of nixpkgs in place to add and modify its functionality.

      overlays = import ./nixos/overlays // {
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
