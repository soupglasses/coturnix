{...}: {
  mkSystem = import ./mkSystem.nix;
  fetchPatchFromNixpkgs = import ./fetchPatchFromNixpkgs.nix;
}
