{ pkgs, ... }:
{
  imports = [
    ./grc.nix
  ];

  programs.starship.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      source ${./zsh-files/autols.zsh};
      source ${./zsh-files/copypaste.zsh};
      source ${../../../../configs/zsh/.zshrc};
    '';
    shellGlobalAliases = {
      # Multi-dot expansion
      "..." =  "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };
  }; 
}
