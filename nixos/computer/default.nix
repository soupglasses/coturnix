{
  config,
  lib,
  ...
}: {
  imports = [../common];

  boot.kernel.sysctl = {
    # Enable SysRq Magic keys.
    "kernel.sysrq" = 1;
  };

  # Use a bigger font for the console.
  console.earlySetup = true;
  console.font = "Lat2-Terminus16";

  # Internationalization
  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Europe/Copenhagen";
  console.keyMap = "no";
  services.xserver.layout = "no";
  services.xserver.xkbVariant = "nodeadkeys";

  # A DBus service that allows applications to update firmware.
  services.fwupd.enable = true;
  # Allow microcode/firmware updates to be applied to the system.
  hardware.enableRedistributableFirmware = true;

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
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
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
  # Allow systemd-timesyncd to pull NTP data directly from an IP based NTP server as a fallback.
  # This is helpful for situations when local time has shifted so much that HTTPS/DNSSEC refuse to function,
  # leading to a catch-22.
  services.timesyncd.extraConfig = "FallbackNTP=162.159.200.1 2606:4700:f1::1"; # time.cloudflare.com

  # Use network-manager for networking on computers.
  networking.useDHCP = false;
  networking.useNetworkd = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  # Ensure DNS over TLS is disabled by default, and only used when explicitly defined (see below).
  networking.networkmanager.connectionConfig.connection.dns-over-tls = "0";

  # Use resolved for DNS.
  services.resolved.enable = true;
  services.resolved.llmnr = "false";
  services.resolved.dnssec = "allow-downgrade";
  services.resolved.extraConfig = ''
    MulticastDNS=no
  '';

  # Do not use default DNS servers. Trips up scoping for VPN connections down the line.
  # Use `nmcli connection modify <connection> ipv<4/6>.dns "<comma separated dns list>"`.
  # For DNS over TLS, use the above command to set the DNS as a pattern of `ip-address#domain.tld`,
  # then enable DNS over TLS with `nmcli connection modify <connection> connection.dns-over-tls 1`.
  # Further, setting `nmcli connection modify <connection> ipv4.ignore-auto-dns 1` is a good idea to
  # ensure that you stop broadcasting queries to the default plain-text DNS, since resolved will run
  # all queries in parallel.
  networking.nameservers = lib.mkForce [""];
  services.resolved.fallbackDns = lib.mkForce [""];

  # Wireguard trips up the default rpfilter, add exceptions for the service manually.
  networking.firewall.extraCommands = ''
    ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
    ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
  '';
  networking.firewall.extraStopCommands = ''
    ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
    ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
  '';
}
