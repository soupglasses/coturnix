{pkgs, lib, ...}:
{
  imports = [
    ./hardware.nix
    ../desktop/modules/chromium.nix
    ../desktop/modules/spell.nix
    ../desktop/modules/desktops/gnome.nix
    ../desktop/modules/keyboard/interception.nix
    ../../mixins/smartcard.nix
  ];

  # Gaming
  nix.settings = {
    substituters = ["https://ezkea.cachix.org"];
    trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  };
  programs.anime-game-launcher.enable = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "yoga";

  virtualisation.podman.enable = true; # For toolbox.

  services.onedrive.enable = true;

  programs.nix-ld.enable = true;

  programs.gamemode.enable = true;
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
    wl-clipboard
  ];

  system.stateVersion = "23.05"; # No touch.
}
