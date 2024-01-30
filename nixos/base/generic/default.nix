{
  _file = ./default.nix;
  imports = [
    ./networking.nix
    ./nix.nix
    ./openssh.nix
    ./packages.nix
    ./upgrade-diff.nix
    ./well-known.nix
  ];

  # Allow sudo from the @wheel group
  security.sudo.enable = true;
}
