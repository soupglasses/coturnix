{inputs}: {
    # The common module holding the settings and modules that all our NixOS
    # configurations should include.
    commonModule = {
      _file = ./flake.nix;
      imports = [
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
      ];
      config = {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.permittedInsecurePackages = [
          "dhcp-4.4.3-P1" # Due to `cloud-init` requiring deprecated `dhclient`.
        ];
        nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
        # Add hashes and dates from our flake to the NixOS version, easily see the status
        # of a server with `nixos-version`.
        system.nixos.versionSuffix =
          nixpkgs.lib.mkForce ".${
            nixpkgs.lib.substring 0 8 (self.lastModifiedDate or self.lastModified)
          }.${
            self.shortRev or "dirty"
          }";
        # Modified repos have no formal revision id. Drop setting revisions if the repo is modified.
        # See: https://github.com/NixOS/nix/pull/5385
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
      };
}
