{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (aspellWithDicts (d: [d.en d.nb d.da]))

    hyphen
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.da_DK
    hunspellDicts.de_DE
    hunspellDicts.nb_NO
    hunspellDicts.nn_NO
  ];

  environment.pathsToLink = ["/share/hunspell" "/share/myspell" "/share/hyphen"];
  environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
}
