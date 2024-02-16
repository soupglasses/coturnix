{pkgs, ...}: {
  # Enable and set monado as our default OpenXR runtime.
  services.monado.enable = true;
  services.monado.defaultRuntime = true;

  systemd.user.services.monado.environment = {
    # Lighthouse defaults: https://gitlab.com/gabmus/envision/-/blob/main/src/profiles/lighthouse.rs
    #XRT_COMPOSITOR_SCALE_PERCENTAGE = "140";
    #XRT_COMPOSITOR_COMPUTE = "1";
    #XRT_DEBUG_GUI = "1";
    #XRT_CURATED_GUI = "1";
    #U_PACING_APP_USE_MIN_FRAME_PERIOD = "1";
    STEAMVR_LH_ENABLE = "true";

    # Profile defaults: https://gitlab.freedesktop.org/monado/monado/-/blob/4548e1738591d0904f8db4df8ede652ece889a76/src/xrt/targets/service/monado.in.service#L12
    XRT_COMPOSITOR_LOG = "debug";
    XRT_PRINT_OPTIONS = "on";
    IPC_EXIT_ON_DISCONNECT = "off";
  };

  # Add opencomposite API and helper for OpenVR support.
  environment.systemPackages = with pkgs; [
    opencomposite
    opencomposite-helper
  ];
}
