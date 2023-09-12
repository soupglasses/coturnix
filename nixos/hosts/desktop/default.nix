{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ./modules/chromium.nix
    ./modules/spell.nix
    ./modules/desktops/gnome.nix
    ./modules/hardware/nvidia.nix
    ./modules/keyboard/interception.nix

    ../../mixins/smartcard.nix
  ];

  # Gaming
  nix.settings = {
    substituters = ["https://ezkea.cachix.org"];
    trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };
  programs.anime-game-launcher.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [
    # mitigations=off only has minimal performance improvements on Intel, as the
    # default mitigations under linux leave SMT enabled. You may check this with:
    #   $ grep . /sys/devices/system/cpu/vulnerabilities/*
    # From personal testing, I saw about a 1-3% penalty for keeping this on auto.
    # https://linuxreviews.org/HOWTO_make_Linux_run_blazing_fast_(again)_on_Intel_CPUs#Performance_implications
    "mitigations=auto"
    # Remove artificial penalties for split locks, which is useful for games run
    # through Proton.
    # https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
    "split_lock_detect=off"
  ];

  services.openssh = {
    enable = true;
  };

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

  programs.gamemode.enable = true;

  services.ratbagd.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    #package = pkgs.steam.override {
    #  extraLibraries = p: with p; [
    #    (lib.getLib networkmanager) # for libnm.so
    #  ];
    #};
  };

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
    lutris
    alsaUtils
    spotify
    heroic
    easyeffects
    (wrapOBS {
      plugins = [
        obs-studio-plugins.obs-vkcapture
      ];
    })
    deluge
    piper
    mangohud
    gimp
    strawberry
    calibre
  ];
  system.stateVersion = "22.05"; # Do not touch.
}
