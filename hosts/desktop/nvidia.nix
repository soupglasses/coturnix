{ config, pkgs, lib, ... }:
{
  # Steam has a soft 32-bit requirement for a lot of games.
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Initialize NVIDIA drivers in kernel space, which helps with performance
  # slightly.
  hardware.nvidia.modesetting.enable = true;

  # Patch the NVIDIA driver with https://github.com/keylase/nvidia-patch
  # This enables NVENC and NvFBC functionality on consumer-grade GPUs.
  hardware.nvidia.package = pkgs.nur.repos.arc.packages.nvidia-patch.override {
    nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
