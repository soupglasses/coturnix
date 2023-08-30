{
  config,
  pkgs,
  ...
}: {
  # Steam has a soft 32-bit requirement for a lot of games.
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Initialize NVIDIA drivers in kernel space, which helps with performance
  # slightly.
  hardware.nvidia.modesetting.enable = true;

  # Downgrade due to regression: https://github.com/NVIDIA/open-gpu-kernel-modules/issues/511
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "535.98";
    sha256_64bit = "sha256-E1DAmVLTe+L5DWCONq47BQtE/Rb22akZMHGhK/0FTsM=";
    sha256_aarch64 = "sha256-ikqj7bvSvCGlkDviaqagyoSZhpf6ZU3TiKKxNDZm3RU=";
    openSha256 = "sha256-dgc5Z70NSpBARelNy6XaZ4e7Tz9vWJWeNek3TSztJus=";
    settingsSha256 = "sha256-jCRfeB1w6/dA27gaz6t5/Qo7On0zbAPIi74LYLel34s=";
    persistencedSha256 = "sha256-WviDU6B50YG8dO64CGvU3xK8WFUX8nvvVYm/fuGyroM=";
  };

  services.xserver.videoDrivers = ["nvidia"];

  # Stop hardware flickering
  hardware.nvidia.powerManagement.enable = true;

  # Enable vaapi support
  hardware.opengl.extraPackages = with pkgs; [vaapiVdpau];

  #  hardware.opengl.extraPackages = [
  #    (pkgs.runCommand "nvidia-icd" { } ''
  #      mkdir -p $out/share/vulkan/icd.d
  #      cp ${pkgs.linuxPackages.nvidia_x11}/share/vulkan/icd.d/nvidia_icd.x86_64.json $out/share/vulkan/icd.d/nvidia_icd.json
  #    '')
  #  ];
}
