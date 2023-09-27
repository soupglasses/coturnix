{
  config,
  lib,
  ...
}: {
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
  # TODO: Figure out a non-networking requiring solution for this.
  services.timesyncd.enable = true;

  # Use network-manager for networking on computers.
  networking.useDHCP = false;
  networking.useNetworkd = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.connectionConfig = {
    "connection.dns-over-tls" = "0";
  };

  # Documentation: https://networkmanager.dev/docs/api/latest/NetworkManager-dispatcher.html
  #networking.networkmanager.dispatcherScripts = [
  #  {
  #    # WORKAROUND: https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/issues/1109
  #    type = "basic";
  #    source = pkgs.writeText "vpn-prevent-leaks" ''
  #      if [ "$NM_DISPATCHER_ACTION" = "vpn-up" ]; then
  #        ${pkgs.systemd}/bin/resolvectl dnssec $VPN_IP_IFACE no
  #        ${pkgs.systemd}/bin/resolvectl dnsovertls $VPN_IP_IFACE no
  #      fi
  #    '';
  #  }
  #];

  # Use resolved for TLS + DNSSEC based DNS.
  services.resolved.enable = true;
  services.resolved.llmnr = "false";
  services.resolved.dnssec = "allow-downgrade";
  services.resolved.extraConfig = ''
    MulticastDNS=no
    DNSOverTLS=no
  '';

  # Default DNS servers.
  networking.nameservers = [
    "1.1.1.1#cloudflare-dns.com"
    "1.0.0.1#cloudflare-dns.com"
    "2606:4700:4700::1111#cloudflare-dns.com"
    "2606:4700:4700::1001#cloudflare-dns.com"
  ];
  services.resolved.fallbackDns = lib.mkForce [""];

  # wireguard trips rpfilter up
  networking.firewall.extraCommands = ''
    ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
    ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
  '';
  networking.firewall.extraStopCommands = ''
    ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
    ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
  '';
}
