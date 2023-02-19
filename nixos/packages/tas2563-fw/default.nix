# Taken from: https://github.com/Myaats/system/blob/main/common/overlays/local/tas2563-fw.nix
{
  stdenvNoCC,
  fetchurl,
  innoextract,
}:
stdenvNoCC.mkDerivation rec {
  pname = "tas2563-fw-14arb7";
  version = "6.0.9388.1_D240_F5894_T1.1.2_Yoga_C770_AMD_0304";

  src = fetchurl {
    url = "https://download.lenovo.com/consumer/mobiles/h5yd027fbfyy7kd0.exe";
    hash = "sha256-hUmPCn6apxXdrSF1kMu3g74PL6ClItIJ9/tMjmmos4M=";
  };

  unpackPhase = ''
    ${innoextract}/bin/innoextract ${src}
  '';

  installPhase = ''
    install -D ./code\$GetExtractPath\$/Source/ThirdParty/TI/TAS2563Firmware.bin \
      $out/lib/firmware/TAS2563Firmware.bin
  '';

  phases = ["unpackPhase" "installPhase"];
}
