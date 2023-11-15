{pkgs, ...}: let
in {
  imports = [
    ./amd-gpu.nix
    ./kernel.nix
  ];

  # Speakers
  hardware.i2c.enable = true;
  hardware.i2c.group = "wheel";
  environment.systemPackages = with pkgs; [
    i2c-tools
  ];

  systemd.services.yoga-bass-speaker-fix = {
    after = ["systemd-suspend.service" "systemd-hibernate.service"];
    requiredBy = ["systemd-suspend.service" "systemd-hibernate.service"];
    wantedBy = ["multi-user.target"];
    description = "Triggers the yoga7 bass-speaker toggle with i2c on boot and resume.";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = pkgs.writeShellScript "yoga-bass-speaker-fix" ''
        ${pkgs.i2c-tools}/bin/i2cset -y 3 0x48 0x2 0 && echo "Successfully applied speaker fix!"
      '';
    };
  };

  # Automatic screen orientation
  hardware.sensor.iio.enable = true;

  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];

  services.xserver.wacom.enable = true;
}
