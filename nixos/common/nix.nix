{lib, ...}: {
  # Automatically garbage collect the nix store.
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 14d";

  # Allow nix to free derivations as a last resort if the drive fills up.
  nix.settings.min-free = lib.mkDefault (100 * 1024 * 1024); # 100 MiB
  nix.settings.max-free = lib.mkDefault (1024 * 1024 * 1024); # 1 GiB

  # Enable nix flake commands on host.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # TODO: Use signature verification for NARs.
  # Allows users in `@wheel` to be ultimately trusted, so we can import unsigned NARs.
  nix.settings.trusted-users = ["root" "@wheel"];

  # Stop needless copies over ssh by allowing substitution on builders.
  nix.settings.builders-use-substitutes = true;

  # Fall back if subsituters are not available quickly enough.
  nix.settings.connect-timeout = 5;
}
