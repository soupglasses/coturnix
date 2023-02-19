# Taken from: https://github.com/Myaats/system/blob/main/devices/shun/quirks.nix
{pkgs, ...}: {
  boot.coturnix.kernelModulePatches = [
    # Add driver for Lenovo YMC (WMI).
    {
      name = "[RFC] Add Lenovo Yoga Mode Control driver";
      patches = [
        (pkgs.fetchpatch {
          name = "Add-Lenovo-Yoga-Mode-Control-driver.patch";
          url = "https://gist.githubusercontent.com/Myaats/260d95b1ae7c3007524c7411f46a40d7/raw/eba099a0e57cb4704ad7d23804d7f7379fd7dc88/lenovo_ymc.patch";
          sha256 = "sha256-qNR4SbhYFNQiHkYg1QCQ9kB4dWN1SBBATLD4st2M+XU=";
        })
      ];
      modules = ["drivers/platform/x86/ideapad-laptop" "drivers/platform/x86/lenovo-ymc"];
    }
    {
      name = "Build tas2562 driver w/ patches";
      patches = [
        (pkgs.fetchpatch {
          name = "Add-tas2562-driver-w-patches";
          url = "https://raw.githubusercontent.com/Myaats/system/b80faaf8675632d3f9f9d9783573c6f050b0f2d1/devices/shun/tas2563-acpi.diff";
          sha256 = "sha256-DsJbCl84z1D2wGIOqmm/o01wkpNDIcwfdpckqtbNLHA=";
        })
      ];
      modules = ["sound/soc/codecs/snd-soc-tas2562"];
    }
  ];

  hardware.i2c = {
    enable = true;
    group = "wheel";
  };

  # Expose input switches to userspace.
  services.udev.extraRules = ''
    KERNEL=="event[0-9]*", ENV{ID_INPUT_SWITCH}=="1", MODE:="0666"
  '';

  # Stop the volume keys from going sticky
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
      KEYBOARD_KEY_ae=!volumedown
      KEYBOARD_KEY_b0=!volumeup
  '';
}
