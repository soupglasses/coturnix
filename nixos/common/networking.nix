{config, lib, ...}: {
  config = {
    # Allow PMTU / DHCP
    networking.firewall.allowPing = true;

    # Use networkd for networking by default.
    networking.useNetworkd = lib.mkDefault true;
    networking.useDHCP = lib.mkDefault false;

    # Enable firewall by default.
    networking.firewall.enable = lib.mkDefault true;
  } // lib.mkIf config.networking.useNetworkd {
  # Do not take down the network on updates, services might fail to resolve if systemd-networkd is stopped.
  # Under the hood will use `systemctl restart service` over the default `systemctl stop/start service`.
  systemd.services.systemd-networkd.stopIfChanged = false;
  systemd.services.systemd-resolved.stopIfChanged = false;
  };
}

