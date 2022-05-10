{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      style = "header,changes,numbers";
      theme = "tokyo-night";
    };
    themes = {
      tokyo-night = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "enkia";
        repo = "enki-theme";
        rev = "0b629142733a27ba3a6a7d4eac04f81744bc714f";
        sha256 = "sha256-Q+sac7xBdLhjfCjmlvfQwGS6KUzt+2fu+crG4NdNr4w=";
      } + "/scheme/Enki-Tokyo-Night.tmTheme");
    };
  };

  home.shellAliases = {
    cat = "bat -pp";
  };
}
