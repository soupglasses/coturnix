{lib}: (
  self: args: let
    nixpkgs =
      if builtins.hasAttr "patches" args && args.patches != []
      then
        (import self.inputs.nixpkgs {inherit (args) system;}).applyPatches {
          name = "nixpkgs-patched";
          src = self.inputs.nixpkgs;
          inherit (args) patches;
        }
      else self.inputs.nixpkgs;
  in
    import "${builtins.toString nixpkgs}/nixos/lib/eval-config.nix" {
      inherit (args) system;
      modules =
        args.modules
        ++ [
          {
            # TODO: Rework this into a module using allowUnfreePredicate.
            nixpkgs.config.allowUnfree = true;

            # TODO: Don't just use all overlays like this.
            nixpkgs.overlays = lib.attrValues self.overlays;

            # Add hashes and dates from our flake to the NixOS version, easily see the status
            # of a machine with `nixos-version`.
            system.nixos.versionSuffix =
              lib.mkForce ".${
                lib.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")
              }.${
                self.shortRev or "dirty"
              }";
            # Modified repos have no formal revision id. Drop setting revisions if the repo is modified.
            # See: https://github.com/NixOS/nix/pull/5385
            system.nixos.revision = lib.mkIf (self ? rev) self.rev;
          }
        ];
    }
)
