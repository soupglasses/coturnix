{ config, pkgs, lib, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    (aspellWithDicts (d: [ d.en d.nb d.da ]))

    hyphen
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.da_DK
    hunspellDicts.de_DE
    inputs.nixpkgs-nightly.legacyPackages."x86_64-linux".hunspellDicts.nb_NO
    inputs.nixpkgs-nightly.legacyPackages."x86_64-linux".hunspellDicts.nn_NO
  ];

  environment.pathsToLink = [ "/share/hunspell" "/share/myspell" "/share/hyphen" ];
  environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
}
