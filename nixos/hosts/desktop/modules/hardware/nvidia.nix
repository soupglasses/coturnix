{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  # While not technically a requirement for nvidia, we typically want hardware acceleration
  # enabled by default with nvidia drivers.
  hardware.opengl.enable = true;

  # Steam has a soft 32-bit requirement for a lot of games.
  hardware.opengl.driSupport32Bit = true;

  # Initialize NVIDIA drivers in kernel space, which helps with performance
  # slightly.
  hardware.nvidia.modesetting.enable = true;

  # Manually managed nvidia package. Update by fetching changes in:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "535.113.01";
    sha256_64bit = "sha256-KOME2N/oG39en2BAS/OMYvyjVXjZdSLjxwoOjyMWdIE=";
    sha256_aarch64 = "sha256-mw/p5ELGTNcM4P94soJIGqpLMBJHSPf+z9qsGnISuCk=";
    openSha256 = "sha256-SePRFb5S2T0pOmkSGflYfJkJBjG3Dx/Z0MjwnWccfcI=";
    settingsSha256 = "sha256-hiX5Nc4JhiYYt0jaRgQzfnmlEQikQjuO0kHnqGdDa04=";
    persistencedSha256 = "sha256-V5Wu8a7EhwZarGsflAhEQDE9s9PjuQ3JNMU1nWvNNsQ=";
  };

  # Stop hardware flickering.
  hardware.nvidia.powerManagement.enable = true;

  # Enable vaapi support.
  hardware.nvidia.open = true;
  hardware.opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
  environment.variables = {
    # Libva is surprisingly bad at auto-detecting drivers.
    # Without this, libva thinks we have no driver support for video acceleration.
    LIBVA_DRIVER_NAME = "nvidia";
    # OpenGL is bad at auto-detecting drivers.
    # Always prioritizes nouveau, regardless if it's blacklisted.
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # GBM is bad at auto-detecting drivers.
    # Technically only reported as an issue under Wayland, but at this point I got
    # trust issues with these library detection features.
    GBM_BACKEND = "nvidia-drm";
    # EXPERIMENTAL: Use direct bindings for nvidia-vaapi to support Nvidia 525+.
    NVD_BACKEND = "direct";
    # Firefox needs an extra hand to support va-api on nvidia.
    # NOTE: This requires extra configuration, see:
    # https://github.com/elFarto/nvidia-vaapi-driver#firefox
    MOZ_X11_EGL = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
