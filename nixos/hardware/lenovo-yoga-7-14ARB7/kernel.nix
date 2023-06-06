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


  boot.kernelPatches = [
    {
      name = "drm-amd-display-fix-flickering-caused-by-S-G-mode.patch";
      patch = pkgs.fetchpatch {
        name = "drm-amd-display-fix-flickering-caused-by-S-G-mode.patch";
        url = "https://gitlab.freedesktop.org/drm/amd/uploads/ebd02a1dc605110a3f28b9c4eb62c313/0001-drm-amd-display-fix-flickering-caused-by-S-G-mode.patch";
        sha256 = "sha256-7Y5xzvxY9jXWu7BIQayKYMA9ONqE3c4ehgOg4CHg1KQ=";
      };
    }
  ];
}
