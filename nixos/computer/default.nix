{config, lib, ...}: {
  _file = ./default.nix;
  imports = [../common];

  boot.kernel.sysctl = {
    # Enable SysRq Magic keys.
    "kernel.sysrq" = 1;
  };

  # Use a bigger font for the console.
  console.font = "Lat2-Terminus16";

  # Internationalization
  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Europe/Copenhagen";
  console.keyMap = "no";
  services.xserver.layout = "no";
  services.xserver.xkbVariant = "nodeadkeys";

  # A DBus service that allows applications to update firmware.
  services.fwupd.enable = true;

  # Check SMART health for all disks.
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.x11.enable =
      if config.services.xserver.enable
      then true
      else false;
    notifications.wall.enable = false;
  };

  # Use pipewire for audio by default.
  security.rtkit.enable = lib.mkDefault config.services.pipewire.enable;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };

  # Default to sane I/O schedulers for the different kinds of devices.
  boot.kernelModules = ["bfq"];
  services.udev.extraRules = ''
    # set scheduler for NVMe
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="mq-deadline"
    # set scheduler for SSD and eMMC
    ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
    # set scheduler for rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';

  # Decrease the total allowed journal size.
  services.journald.extraConfig = ''
    SystemMaxUse=500M
  '';

  # Use systemd-timesyncd NTP for synchronizing the system clock.
  services.timesyncd.enable = true;

  # Use network-manager for networking on computers.
  networking.useDHCP = false;
  networking.useNetworkd = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];
}
