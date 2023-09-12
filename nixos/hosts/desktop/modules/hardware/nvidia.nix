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
    version = "535.104.05";
    sha256_64bit = "sha256-L51gnR2ncL7udXY2Y1xG5+2CU63oh7h8elSC4z/L7ck=";
    sha256_aarch64 = "sha256-J4uEQQ5WK50rVTI2JysBBHLpmBEWQcQ0CihgEM6xuvk=";
    openSha256 = "sha256-0ng4hyiUt0rHZkNveFTo+dSaqkMFO4UPXh85/js9Zbw=";
    settingsSha256 = "sha256-pS9W5LMenX0Rrwmpg1cszmpAYPt0Mx+apVQmOmLWTog=";
    persistencedSha256 = "sha256-uqT++w0gZRNbzyqbvP3GBqgb4g18r6VM3O8AMEfM7GU=";
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
