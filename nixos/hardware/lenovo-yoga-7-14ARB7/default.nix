{...}: {
  imports = [
    ./amd-gpu.nix
    ./kernel.nix
    ./sensors.nix
    ./quirks.nix
  ];

  services.xserver.wacom.enable = true;
}
