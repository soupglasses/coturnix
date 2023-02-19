{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland =
      if (builtins.elem "nvidia" config.services.xserver.videoDrivers)
      then false
      else true;
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    impatience
  ];

  services.dbus.enable = true;
  services.udev.packages = [pkgs.gnome.gnome-settings-daemon];

  hardware.pulseaudio.enable = false;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;
  services.pipewire.media-session.enable = false;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.alsa.enable = true;
}
