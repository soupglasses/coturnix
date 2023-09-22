{
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelParams = ["mem_sleep_default=deep" "amd_pstate=active"];
  #boot.extraModulePackages = with config.boot.kernelPackages; [zenpower];
  #boot.kernelModules = ["kvm-amd" "amd-pstate" "zenpower"];
  #boot.blacklistedKernelModules = ["acpi_cpufreq" "k10temp"]; # Disable ACPI cpufreq (in favor of p-state), and k10temp for zenpower

  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  hardware.cpu.amd.updateMicrocode = true;
}
