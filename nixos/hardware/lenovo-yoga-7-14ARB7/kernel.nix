{config, pkgs, lib, ...}: {
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  boot.kernelParams = ["mem_sleep_default=deep" "amd_pstate=passive"];
  boot.extraModulePackages = with config.boot.kernelPackages; [zenpower];
  boot.kernelModules = ["kvm-amd" "amd-pstate" "zenpower" "snd_soc_tas2562"];
  boot.blacklistedKernelModules = ["acpi_cpufreq" "k10temp"]; # Disable ACPI cpufreq (in favor of p-state), and k10temp for zenpower

  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [pkgs.coturnix.tas2563-fw];
}
