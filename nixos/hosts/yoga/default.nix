{pkgs, ...}:
{
  imports = [./hardware.nix];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "yoga";

  environment.shells = [pkgs.zsh];
  users.users.sofi = {
    description = "Sofi";
    shell = pkgs.zsh;
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
