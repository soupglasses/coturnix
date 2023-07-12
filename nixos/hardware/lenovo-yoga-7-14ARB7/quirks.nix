# Taken from: https://github.com/Myaats/system/blob/main/devices/shun/quirks.nix
{...}: {
  hardware.i2c = {
    enable = true;
    group = "wheel";
  };

  # Expose input switches to userspace.
  # services.udev.extraRules = ''
  #   KERNEL=="event[0-9]*", ENV{ID_INPUT_SWITCH}=="1", MODE:="0666"
  # '';

  # Stop the volume keys from going sticky
  # services.udev.extraHwdb = ''
  #   evdev:atkbd:dmi:*
  #     KEYBOARD_KEY_ae=!volumedown
  #     KEYBOARD_KEY_b0=!volumeup
  # '';
}
