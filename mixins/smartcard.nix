{pkgs, ...}: {
  # Enable Smart Card support.
  # NOTE: This requires sc-daemon to be set with `disable-ccid`.
  services.pcscd.enable = true;

  # Expose smart cards to userspace.
  hardware.gpgSmartcards.enable = true;

  # Add basic Yubikey support.
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Add user management packages
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
  ];
}
