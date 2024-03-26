# Implements features as given in https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3331
(final: prev: {
  # Mutter direct mode experimental support.
  monado = prev.monado.overrideAttrs (monado_attrs: {
    patches =
      (monado_attrs.patches or [])
      ++ [
        (final.fetchpatch {
          url = "https://gitlab.freedesktop.org/swick/monado/-/commit/572aa17012feca49ad369f97fbba4f7ccc008bd9.patch";
          sha256 = "sha256-AI07W2QjCZO7Z+Rb4wmiwP6mdj6GDcvgCVwR7udBUfg=";
        })
      ];
  });
  gnome = prev.gnome.overrideScope (_gnome_final: gnome_prev: {
    mutter = gnome_prev.mutter.overrideAttrs (mutter_attrs: {
      version = "45.0";
      src = final.fetchurl {
        url = "https://gitlab.gnome.org/GNOME/mutter/-/archive/affc8c56964e30b0227732b08fb307ec93cc745c/mutter-affc8c56964e30b0227732b08fb307ec93cc745c.tar.gz";
        sha256 = "sha256-JoQND07TOZG45yU+51MAaC89Arxcgg30wfU48QEtz48=";
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
      #outputs = [ "out" "dev" "man" ];
      #patches =
      #  (mutter_attrs.patches or [])
      #  ++ [];
    });
  });
})
