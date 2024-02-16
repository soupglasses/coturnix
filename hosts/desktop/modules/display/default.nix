{pkgs, ...}: let
  # You can test EDID files live by `cat ./edid.bin > /sys/kernel/debug/dri/0/<DISPLAY>/edid_override` as root.
  edid-msi1462 = pkgs.runCommandNoCC "edid-msi1462" {compressFirmware = false;} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./msi1462.bin} "$out/lib/firmware/edid/msi1462.bin"
  '';
in {
  boot.kernelParams = ["drm.edid_firmware=DP-2:edid/msi1462.bin"];
  hardware.firmware = [edid-msi1462];

  services.xserver.deviceSection = ''
    # TearFree should automatically be disabled when VRR is used.
    Option "TearFree" "auto"
    # Enable VRR (FreeSync) on XOrg when available.
    Option "VariableRefresh" "true"
    # Separately flip secondary displays, decouples their tied refreshrate from your primary monitor.
    # NOTE: This can lead to tearing on your secondary display(s).
    Option "AsyncFlipSecondaries" "true"
  '';
}
