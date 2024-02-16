{ config, lib, pkgs, ... }:
{
  programs.navi = {
    enable = true;
    settings = {
      style = {
        tag = {
          # Text color, see: https://bit.ly/3gloNNI
          color = "cyan";
          # Column width relative to terminal window
          width_percentage = 26;
          # Column width by character
          min_width = 20;
        };
        comment = {
          color = "blue";
          width_percentage = 42;
          min_width = 45;
        };
        snippet = {
          color = "white";
        };
      };
      cheats = {
        paths = [
          "${./cheats}"
        ];
      };
      shell = { command = "zsh"; };
    };
  };

	home.shellAliases = {
		cheat = "navi --print";
	};
}
