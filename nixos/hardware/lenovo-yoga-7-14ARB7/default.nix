{...}: {
  _file = ./default.nix;
  imports = [
    ./amd-gpu.nix
    ./kernel.nix
    ./sensors.nix
    ./quirks.nix
    ./wacom.nix
  ];
}
