{stdenv, fetchFromGitHub}:

stdenv.mkDerivation {
  name = "ps3iso-utils";
  version = "277db7de";

  src = fetchFromGitHub {
    owner = "bucanero";
    repo = "ps3iso-utils";
    rev = "878090980a9042c61901920fed1b034af215e8c7";
    hash = "sha256-HUx5BqHBvVMUHReuJL0RcyxXOnufSt1Zi/ieAlI2eoc=";
  };

  buildPhase = ''
    mkdir -p bin/
    find . -type f -name "*.c" -exec \
    sh -c 'OFILE=`basename "{}" ".c"` && gcc "{}" -o bin/"$OFILE"' \;
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';
}
