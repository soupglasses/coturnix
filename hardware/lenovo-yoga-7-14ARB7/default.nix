{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../amd/gpu.nix
  ];

  # Kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  #boot.kernelParams = ["mem_sleep_default=deep" "amd_pstate=active"];
  #boot.extraModulePackages = with config.boot.kernelPackages; [zenpower];
  #boot.kernelModules = ["kvm-amd" "amd-pstate" "zenpower"];
  #boot.blacklistedKernelModules = ["acpi_cpufreq" "k10temp"]; # Disable ACPI cpufreq (in favor of p-state), and k10temp for zenpower

  # Microcode for AMD CPU.
  hardware.cpu.amd.updateMicrocode = true;

  # Speakers
  #hardware.i2c.enable = true;
  #hardware.i2c.group = "wheel";
  #environment.systemPackages = with pkgs; [
  #  i2c-tools
  #];
  #systemd.services.yoga-bass-speaker-fix = {
  #  after = ["systemd-suspend.service" "systemd-hibernate.service"];
  #  requiredBy = ["systemd-suspend.service" "systemd-hibernate.service"];
  #  wantedBy = ["multi-user.target"];
  #  description = "Triggers the yoga7 bass-speaker toggle with i2c on boot and resume.";
  #  serviceConfig = {
  #    Type = "oneshot";
  #    User = "root";
  #    ExecStart = pkgs.writeShellScript "yoga-bass-speaker-fix" ''
  #      ${pkgs.i2c-tools}/bin/i2cset -y 3 0x48 0x2 0 && echo "Successfully applied speaker fix!"
  #    '';
  #  };
  #};

  # Automatic screen orientation
  hardware.sensor.iio.enable = true;

  # Help flickering of screen due to bug in 6800U
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];

  # Enable built-in wacom pen support
  services.xserver.wacom.enable = true;
}
