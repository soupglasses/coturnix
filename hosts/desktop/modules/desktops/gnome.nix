{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = if (builtins.elem "nvidia" config.services.xserver.videoDrivers) then false else true;
    };
    desktopManager.gnome.enable = true;
  };

  #services.dbus.enable = true;
  #services.dbus.packages = [ pkgs.gnome3.dconf ];
  #services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
