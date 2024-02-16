# My reimplementation of `nixpkgs.lib.nixosSystem` function:
#
# This reimplementation adds extra arguments for ease of use:
# - a `patches` argument to allow patching nixpkgs.
# - a `nixpkgs` argument to allow you to define your nixpkgs source.
# - an `overlays` argument as a quick alias for configuring `nixpkgs.overlays`.
# - both `unfreePackages` and `insecurePackages` as functions to easily define unfree/insecure packages.
(
  self: {
    system ? null,
    nixpkgs ? self.inputs.nixpkgs,
    patches ? [],
    modules ? [],
    overlays ? [],
    unfreePackages ? [],
    insecurePackages ? [],
    extraArgs ? {},
  }: let
    nixpkgs' =
      if patches != [] && system != null
      then
        # Here be dragons! Uses Import From Derivation (IFD): https://nixos.wiki/wiki/Import_From_Derivation
        nixpkgs.legacyPackages.${system}.applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs;
          inherit patches;
        }
      else if patches != [] && system == null
      then abort "Cannot patch nixpkgs without the `system` argument being defined. It is required for IFD."
      else nixpkgs;
  in
    import (nixpkgs' + /nixos/lib/eval-config.nix) {
      inherit system;
      modules =
        modules
        ++ [
          ({lib, ...}: {
            # I am not sure why `extraArgs` got deprecated for `_module.args`.
            _module.args = extraArgs;

            # Allow unfree/insecure packages to be found by their derivation name.
            nixpkgs.config.allowUnfreePredicate = pkg:
              builtins.elem (lib.getName pkg) unfreePackages;
            nixpkgs.config.allowInsecurePredicate = pkg:
              builtins.elem (lib.getName pkg) insecurePackages;

            # Self explanatory, sets our inputted overlays as nixpkgs overlays.
            nixpkgs.overlays = overlays;

            # Add hashes and dates from our flake to the NixOS version, easily see the status
            # of a machine with `nixos-version`.
            system.nixos.versionSuffix =
              lib.mkForce ".${
                lib.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")
              }.${
                self.shortRev or "dirty"
              }";
            system.nixos.revision = lib.mkIf (self ? rev) self.rev;
          })
        ];
    }
)
