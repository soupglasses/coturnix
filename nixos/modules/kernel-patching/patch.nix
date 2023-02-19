# Taken from: https://github.com/Myaats/system/blob/main/common/modules/boot.nix
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.boot.coturnix;
  kernel = config.boot.kernelPackages.kernel;
in {
  options.boot.coturnix = {
    # These are kernel modules that are built with patches and overriding the main kernel modules
    # This is an easier way to patch kernel modules without having to rebuild the kernel
    kernelModulePatches = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            description = "Name of the patch";
            type = types.str;
          };
          patches = mkOption {
            description = "Patch files to apply to the kernel source tree";
            default = [];
            type = types.listOf types.anything;
          };
          modules = mkOption {
            description = "Modules to build and install";
            default = [];
            type = types.listOf types.str;
          };
        };
      });
      default = [];
      description = "List of kernel module patches to rebuild with the current kernel source tree";
    };
  };

  config = mkIf (cfg.kernelModulePatches != []) {
    boot.extraModulePackages = let
      # Group the kernel modules to build by module directory with modules names as list
      kernelModules =
        mapAttrs (_: modules: map (m: baseNameOf m) modules)
        (groupBy (m: dirOf m) (flatten (map (p: p.modules) cfg.kernelModulePatches)));
    in [
      # Override the current kernel
      (pkgs.stdenv.mkDerivation {
        name = "linux-modules-patched-${kernel.version}";
        # Copy the src
        src = kernel.src;
        # Add the existing kernel modules
        nativeBuildInputs = kernel.dev.moduleBuildDependencies;
        # Add the patches
        patches = concatLists (map (km: km.patches) cfg.kernelModulePatches);
        # Find the KDIR for the current kernel
        KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

        # Build the kernel modules
        buildPhase = concatStringsSep "\n" (mapAttrsToList (dir: modules: ''
            # Convert all the modules that should be built to obj-m
            ${concatStringsSep "\n" (map (module: ''
                sed -i "s/obj-\$\(.*\).*\+=.*${module}\.o/obj-m += ${module}.o/" ${dir}/Makefile
              '')
              modules)}
            # Remove all obj-y to avoid building other things
            sed -i "s/obj-y.*+=.*//" ${dir}/Makefile
            # Remove rest of modules so config does not build them
            sed -i "s/obj-\$\(.*\).*\+=.*//" ${dir}/Makefile
            # Build the modules
            make -C $KDIR M=$(realpath ${dir}) modules
          '')
          kernelModules);

        # Install the kernel modules
        installPhase = concatStringsSep "\n" (flatten (mapAttrsToList (dir: modules: (map (module: ''
            # Compress the kernel module
            xz ${dir}/${module}.ko
            # Install it with the same permissions that NixOS uses
            install -vD -m0444 ${dir}/${module}.ko.xz \
              $out/lib/modules/${kernel.modDirVersion}/kernel/${dir}/${module}.ko.xz
          '')
          modules))
        kernelModules));

        # Higher priority than the actual kernel
        meta.priority = 0;
      })
    ];
  };
}
