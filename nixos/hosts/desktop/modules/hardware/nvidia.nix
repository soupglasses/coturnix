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
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "545.29.02";
    sha256_64bit = "sha256-RncPlaSjhvBFUCOzWdXSE3PAfRPCIrWAXyJMdLPKuIU=";
    sha256_aarch64 = "sha256-Y2RDOuDtiIclr06gmLrPDfE5VFmFamXxiIIKtKAewro=";
    openSha256 = "sha256-PukpOBtG5KvZKWYfJHVQO6SuToJUd/rkjpOlEi8pSmk=";
    settingsSha256 = "sha256-zj173HCZJaxAbVV/A2sbJ9IPdT1+3yrwyxD+AQdkSD8=";
    persistencedSha256 = "sha256-mmMi2pfwzI1WYOffMVdD0N1HfbswTGg7o57x9/IiyVU=";
    patchFlags = ["-p1" "-d" "kernel"];
    patches = [];
  };

  services.xserver.screenSection = ''
    # Allow G-Sync compatible displays to have their variable refresh-rate enabled by default.
    Option "MetaModes" "nvidia-auto-select +0+0 {AllowGSYNCCompatible=On}"

    # Do not override the HorizSync/VertRefresh ranges with EDID defaults.
    Option "UseEdidFreqs" "false"
    # Allow overclocking connected monitors. This is overly hacky and i couldn't figure out a more clean way.
    Option "ModeValidation" "AllowNon60hzmodesDFPModes, NoEDIDDFPMaxSizeCheck, NoVertRefreshCheck, NoHorizSyncCheck, NoMaxPClkCheck, AllowNonEdidModes, NoEdidMaxPClkCheck"
  '';
  services.xserver.monitorSection = ''
    # 3440x1440 @ 115.000 Hz Reduced Blank (CVT) field rate 115.000 Hz; hsync: 174.915 kHz; pclk: 615.70 MHz
    Modeline "3440x1440_115.00_rb2"  615.70  3440 3448 3480 3520  1440 1507 1515 1521 +hsync -vsync
  '';

  # Nvidia requires this script constantly running to handle suspending.
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
