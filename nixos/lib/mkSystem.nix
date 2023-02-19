{lib}: (
  self: args:
    self.inputs.nixpkgs.lib.nixosSystem {
      inherit (args) system;
      modules =
        args.modules
        ++ [
          {
            # TODO: Rework this into a module using allowUnfreePredicate.
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = lib.attrValues self.overlays;
            # Add hashes and dates from our flake to the NixOS version, easily see the status
            # of a machine with `nixos-version`.
            system.nixos.versionSuffix =
              lib.mkForce ".${
                lib.substring 0 8 (self.lastModifiedDate or self.lastModified)
              }.${
                self.shortRev or "dirty"
              }";
            # Modified repos have no formal revision id. Drop setting revisions if the repo is modified.
            # See: https://github.com/NixOS/nix/pull/5385
            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          }
        ];
    }
)
