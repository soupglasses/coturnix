{
  pkgs,
  lib,
  ...
}: {
  # Ensure the correct driver is loaded early inside initrd.
  boot.initrd.kernelModules = ["amdgpu"];
  # AMD X Server
  services.xserver.enable = lib.mkDefault true;
  services.xserver.videoDrivers = ["amdgpu"];
  # AMD Vulkan
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.deviceSection = ''
    Option "TearFree" "false"
    Option "VariableRefresh" "true"
  '';
  # Make user-readable symlink for xorg config.
  services.xserver.exportConfiguration = true;

  # Add OpenCL, VDPAU and AMDVLK support to our hardware stack.
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    vaapiVdpau
    libvdpau-va-gl
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  # Debugging tooling for vaapi.
  environment.systemPackages = with pkgs; [
    libva-utils
  ];
}
