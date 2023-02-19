{
  config,
  pkgs,
  lib,
  ...
}: {
  # Steam has a soft 32-bit requirement for a lot of games.
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Initialize NVIDIA drivers in kernel space, which helps with performance
  # slightly.
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = ["nvidia"];

  # Stop hardware flickering
  hardware.nvidia.powerManagement.enable = true;

  #  hardware.opengl.extraPackages = [
  #    (pkgs.runCommand "nvidia-icd" { } ''
  #      mkdir -p $out/share/vulkan/icd.d
  #      cp ${pkgs.linuxPackages.nvidia_x11}/share/vulkan/icd.d/nvidia_icd.x86_64.json $out/share/vulkan/icd.d/nvidia_icd.json
  #    '')
  #  ];
}
