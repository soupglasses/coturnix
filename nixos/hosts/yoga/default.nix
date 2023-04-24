{pkgs, ...}:
{
  imports = [
    ./hardware.nix
    ../desktop/modules/chromium.nix
    ../desktop/modules/spell.nix
    ../desktop/modules/desktops/gnome.nix
    ../desktop/modules/keyboard/interception.nix
    ../../mixins/smartcard.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "yoga";

  virtualisation.podman.enable = true;

  services.onedrive.enable = true;

  programs.nix-ld.enable = true;

  programs.gamemode.enable = true;
  services.ratbagd.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  users.users.sofi = {
    description = "Sofi";
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };

  # Firefox touchscreen support
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  environment.systemPackages = with pkgs; [
    firefox
    xclip
    gcc
    libreoffice
    alsaUtils
    spotify
    piper
    gimp
    lutris
    prismlauncher
    foliate
    toolbox
  ];

  system.stateVersion = "23.05"; # No touch.
}
