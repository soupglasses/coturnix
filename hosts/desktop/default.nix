{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/common.nix
    ./modules/chromium.nix
    ./modules/spell.nix
    ./modules/desktops/gnome.nix
    ./modules/hardware/nvidia.nix
    ./modules/keyboard/interception.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # My poor computer cant handle EFI variables :(
  boot.loader.efi.canTouchEfiVariables = false;
  # Enable the boot splash screen :)
  boot.plymouth.enable = true;

  networking.hostName = "desktop";

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style= "adwaita-dark";
  };

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  environment.shells = [ pkgs.zsh ];
  users.users.sofi = {
    description = "Sofi";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    xclip # needed for nvim
    neovim
    vimPlugins.nvim-treesitter
    gcc
    libreoffice
    lutris
    alsaUtils
    spotify
    heroic
    easyeffects
    (wrapOBS { plugins = [
      obs-studio-plugins.obs-nvfbc
      obs-studio-plugins.obs-vkcapture
    ];})
    mullvad-vpn
    deluge
  ];

  services.mullvad-vpn.enable = true;

  system.stateVersion = "22.05";  # Do not touch.
}

