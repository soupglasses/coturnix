# Based on AUR's `*-vrr` packages:
# - https://aur.archlinux.org/packages/mutter-vrr
# - https://aur.archlinux.org/packages/gnome-control-center-vrr
# After reboot, run `gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"` and relog to enable.
(final: prev: {
  gnome = prev.gnome.overrideScope' (_gnome_final: gnome_prev: {
    mutter = gnome_prev.mutter.overrideAttrs (mutter_attrs: {
      version = "45.3";
      src = final.fetchurl {
        # 45.3 is not yet in any NixOS mirrors? Pulling direct from gitlab by commit-id instead.
        url = "https://gitlab.gnome.org/GNOME/mutter/-/archive/5012d22cb96ba22c4133e2e488ea1f5241fb50e2/mutter-5012d22cb96ba22c4133e2e488ea1f5241fb50e2.tar.gz";
        sha256 = "sha256-AzTW4JL9qL2OAmJulYkHvzIj0p1frQPWeG9rKNlDCDg=";
      };
      buildInputs =
        (mutter_attrs.buildInputs or [])
        ++ [
          final.libdisplay-info
        ];
      mesonFlags =
        (mutter_attrs.mesonFlags or [])
        ++ [
          "-Dlibdisplay_info=true"
        ];
      patches =
        (mutter_attrs.patches or [])
        ++ [
          (final.fetchurl {
            url = "https://aur.archlinux.org/cgit/aur.git/plain/vrr.patch?h=mutter-vrr&id=d01bcacfe9209552c318ac665e4c925f3932e9d4";
            sha256 = "sha256-YC1Uonew8QFDn32YZ5C3hJPBUzz0KMXUr+rFCf7Rous=";
          })
        ];
    });
    gnome-control-center = gnome_prev.gnome-control-center.overrideAttrs (gnome-control-center_attrs: {
      version = "45.2";
      src = final.fetchurl {
        url = "mirror://gnome/sources/gnome-control-center/45.2/gnome-control-center-45.2.tar.xz";
        sha256 = "sha256-DPo8My1u2stz0GxrJv/KEHjob/WerIGbKTHglndT33A=";
      };
      patches =
        (gnome-control-center_attrs.patches or [])
        ++ [
          (final.fetchurl {
            url = "https://aur.archlinux.org/cgit/aur.git/plain/pixmaps-dir.diff?h=gnome-control-center-vrr&id=187de36c6ad45994ec1066344ca27528c8649c28";
            sha256 = "sha256-b56chge5o7fv5aF6mKnR24tzIdDRs7yjC0V5C9Q42R4=";
          })
          (final.fetchurl {
            url = "https://aur.archlinux.org/cgit/aur.git/plain/734.patch?h=gnome-control-center-vrr&id=187de36c6ad45994ec1066344ca27528c8649c28";
            sha256 = "sha256-vGHCgqHESWt35ARj/gZEmYko9iexEu335aRhFMPek/Q=";
          })
        ];
    });
  });
})
