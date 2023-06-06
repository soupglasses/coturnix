{...}: {
  imports = [
    ./amd-gpu.nix
    ./kernel.nix
    ./sensors.nix
    ./quirks.nix
  ];

  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];

  services.xserver.wacom.enable = true;
}
