{ config, pkgs, ...}: {
  # Steam has a soft 32-bit requirement for a lot of games.
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Initialize NVIDIA drivers in kernel space, which helps with performance
  # slightly.
  hardware.nvidia.modesetting.enable = true;

  # Downgrade due to regression: https://github.com/NVIDIA/open-gpu-kernel-modules/issues/511
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "530.41.03";
    sha256_64bit = "sha256-riehapaMhVA/XRYd2jQ8FgJhKwJfSu4V+S4uoKy3hLE=";
    sha256_aarch64 = "sha256-uM5zMEO/AO32VmqUOzmc05FFm/lz76jPSSaQmeZUlFo=";
    openSha256 = "sha256-etbtw6LMRUcFoZC9EDDRrTDekV8JFRYmkp3idLaMk5g=";
    settingsSha256 = "sha256-8KB6T9f+gWl8Ni+uOyrJKiiH5mNx9eyfCcW/RjPTQQA=";
    persistencedSha256 = "sha256-zrstlt/0YVGnsPGUuBbR9ULutywi2wNDVxh7OhJM7tM=";

    patchFlags = [ "-p1" "-d" "kernel" ];
    patches = [
      (pkgs.fetchpatch {
        url = "https://gist.github.com/joanbm/77f0650d45747b9a4dc8e330ade2bf5c/raw/688b612624945926676de28059fe749203b4b549/nvidia-470xx-fix-linux-6.4.patch";
        hash = "sha256-OyRmezyzqAi7mSJHDjsWQVocSsgJPTW5DvHDFVNX7Dk=";
      })
    ];
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
