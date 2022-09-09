{ config, pkgs, lib, ... }:
{
  imports = [ ./nix.nix ];

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
    notifications.x11.enable = if config.services.xserver.enable then true else false;
    notifications.wall.enable = false;
  };

  # Allow realtime scheduling.
  security.rtkit.enable = true;

  # Default to sane I/O schedulers for the different kinds of devices.
  boot.kernelModules = [ "bfq" ];
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

  # Use systemd-timesyncd NTP for syncronizing the system clock.
  services.timesyncd.enable = true;

  # Sane networking defaults.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];  # minecraft
    allowedUDPPorts = [ 25565 ];  # minecraft
  };

  # List of system profile packages.
  environment.systemPackages = with pkgs; [
    # Management
    fd
    git
    htop
    neofetch
    neovim
    openssl
    psmisc  # provides: killall, pstree, etc.
    ripgrep  # provides: rg
    rsync
    tree
    wget

    # Compression & De-compression
    atool  # provides: apack, aunpack, acat, etc.
    bzip2
    gnutar  # provides: tar
    gzip
    lz4
    lzip
    p7zip  # provides: 7z
    xz
    zip
    unzip
    zstd

    # Data formatters
    libxml2  # provides: xmllint
    jq
    yq

    # Networking
    iperf
    nmap

    # Hardware
    ethtool
    lshw
    lsof
    pciutils  # provides: lspci
    smartmontools  # provides: smartctl, etc.
    usbutils  # provides: lsusb
  ];
}
