{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ./modules/chromium.nix
    ./modules/spell.nix
    ./modules/desktops/gnome.nix
    ./modules/keyboard/interception.nix
  ];

  boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  boot.extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=9 exclusive_caps=1 card_label="OBS Virtual Camera"'';

  services.openssh.enable = true;

  programs.ns-usbloader.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux" "i686-linux"];

  # Attempt boot even if the harddrive is offline.
  fileSystems."/mnt/games".options = ["nofail"];
  fileSystems."/mnt/home".options = ["nofail"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # My poor computer can't handle EFI variables :(
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "desktop";

  programs.dconf.enable = true;

  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style = "adwaita-dark";

  services.ratbagd.enable = true;

  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;
  users.users.sofi = {
    description = "Sofi";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvgn0kSAboULv37yLS1fGwByGSudhbQGrP/RrO7+cH+ sofi@mailbox.org"
    ];
  };

  # Watch for changes in https://github.com/NixOS/nixpkgs/issues/248179
  nixpkgs.config.firefox.speechSynthesisSupport = true;

  environment.systemPackages = with pkgs; [
    protontricks
    firefox
    speechd
    xclip
    gcc
    libreoffice
    alsaUtils
    spotify
    easyeffects
    deluge
    piper
    gimp
    strawberry
    calibre
    unityhub
  ];
  system.stateVersion = "22.05"; # Do not touch.
}
