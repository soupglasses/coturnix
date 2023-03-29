_final: prev: {
  libwacom = prev.libwacom.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "linuxwacom";
      repo = "libwacom";
      rev = "a652dcbac2397cc340597299ae3cb28ec3429650";
      hash = "sha256-XokgnFqIxOtLy9Ih+KsGwdMBMC9rjyoWGWsRDwBBKg0=";
    };
    patches = old.patches or [] ++ [
      ./0001-Add-Wacom-HID-52D3-Lenovo-Yoga-7-14ARB7.patch
    ];
  });
}
