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

  environment.systemPackages = with pkgs; [
    gnome-epub-thumbnailer
    gnomeExtensions.appindicator
    gnomeExtensions.impatience
    gnome.gnome-boxes
  ];

  # Manually expose GStreamer plugins for GNOME Files.
  # Watch for fix in https://github.com/NixOS/nixpkgs/issues/53631
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-plugins-ugly
    pkgs.gst_all_1.gst-plugins-libav
  ];

  programs.evolution.enable = true;
  services.gnome.evolution-data-server.enable = true;

  services.dbus.enable = true;
  services.udev.packages = [pkgs.gnome.gnome-settings-daemon];

  hardware.pulseaudio.enable = false;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.alsa.enable = true;
}
