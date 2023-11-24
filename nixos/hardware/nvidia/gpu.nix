{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Initialize NVIDIA drivers in kernel space, which helps with performance
  # slightly.
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  # Manually managed nvidia package. Update by fetching changes in:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #  version = "545.29.02";
  #  sha256_64bit = "sha256-RncPlaSjhvBFUCOzWdXSE3PAfRPCIrWAXyJMdLPKuIU=";
  #  sha256_aarch64 = "sha256-Y2RDOuDtiIclr06gmLrPDfE5VFmFamXxiIIKtKAewro=";
  #  openSha256 = "sha256-PukpOBtG5KvZKWYfJHVQO6SuToJUd/rkjpOlEi8pSmk=";
  #  settingsSha256 = "sha256-zj173HCZJaxAbVV/A2sbJ9IPdT1+3yrwyxD+AQdkSD8=";
  #  persistencedSha256 = "sha256-mmMi2pfwzI1WYOffMVdD0N1HfbswTGg7o57x9/IiyVU=";
  #  patchFlags = ["-p1" "-d" "kernel"];
  #  patches = [];
  #};

  services.xserver.screenSection = ''
    # Allow G-Sync compatible displays to have their variable refresh-rate enabled by default.
    Option "MetaModes" "nvidia-auto-select +0+0 {AllowGSYNCCompatible=On}"
  '';

  # Nvidia requires this script constantly running to handle suspending.
  hardware.nvidia.powerManagement.enable = true;

  # Enable vaapi support.
  hardware.nvidia.open = true;
  hardware.opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
  environment.variables = {
    # Libva is surprisingly bad at auto-detecting nvidia's drivers.
    # Without this, libva thinks we have no driver support for video acceleration.
    LIBVA_DRIVER_NAME = "nvidia";
    # OpenGL is also execcively bad at auto-detecting nvidia's drivers.
    # Always prioritizes nouveau, regardless if it's blacklisted, so we need to force it.
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # GBM is also execcively bad at auto-detecting nvidia's drivers.
    # Technically only reported as an issue under Wayland, but at this point I got
    # trust issues with these library detection features.
    GBM_BACKEND = "nvidia-drm";
    # EXPERIMENTAL: Use direct bindings for nvidia-vaapi to support Nvidia 525+.
    NVD_BACKEND = "direct";
    # Firefox needs an extra hand to support va-api on nvidia.
    # NOTE: This requires extra manual configuration, see:
    # https://github.com/elFarto/nvidia-vaapi-driver#firefox
    MOZ_X11_EGL = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
