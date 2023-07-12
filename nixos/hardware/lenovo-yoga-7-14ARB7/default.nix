{...}: {
  imports = [
    ./amd-gpu.nix
    ./kernel.nix
    ./quirks.nix
  ];

  # Automatic screen orientation
  hardware.sensor.iio.enable = true;

  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];

  services.xserver.wacom.enable = true;
}
