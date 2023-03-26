{pkgs, ...}:
{
  imports = [
    ./hardware.nix
    ../desktop/modules/chromium.nix
    ../desktop/modules/spell.nix
    ../desktop/modules/desktops/gnome.nix
    ../../mixins/smartcard.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "yoga";

  users.users.sofi = {
    description = "Sofi";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    firefox
    xclip
    gcc
    libreoffice
    lutris
    alsaUtils
    spotify
    heroic
    piper
    gimp
    calibre
  ];

  system.stateVersion = "23.05"; # No touch.
}
