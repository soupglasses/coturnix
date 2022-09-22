{ stdenv
, lib
, fetchFromGitHub
, gtk3
, meson
, sassc
, ninja
}:

stdenv.mkDerivation rec {
  pname = "adw-gtk3";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "v${version}";
    sha256 = "sha256-8SD3qnjtIAM40JLo7XZAri3QAA4ot8X1XUtdko1Iml4=";
  };

  nativeBuildInputs = [ gtk3 meson sassc ninja ];

  meta = with lib; {
    description = "An unofficial GTK3 port of libadwaita";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = with licenses; [ lgpl21Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ imsofi ];
  };
}
