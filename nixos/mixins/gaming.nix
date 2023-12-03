{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [
    # mitigations=off only has minimal performance improvements on Intel, as the
    # default mitigations under linux leave SMT enabled. You may check this with:
    #   $ grep . /sys/devices/system/cpu/vulnerabilities/*
    # From personal testing, I saw about a 1-3% penalty for keeping this on auto.
    # https://linuxreviews.org/HOWTO_make_Linux_run_blazing_fast_(again)_on_Intel_CPUs#Performance_implications
    "mitigations=auto"
    # Remove artificial penalties for split locks, which is useful for games run
    # through Proton.
    # https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
    "split_lock_detect=off"
  ];

  boot.kernel.sysctl = {
    # Taken from SteamOS, can help with performance.
    "vm.max_map_count" = 2147483642;
  };

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        DXVK_HUD = "compiler";
      };
    };
    remotePlay.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    mangohud
    prismlauncher
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    })
  ];
  nixpkgs.config.permittedInsecurePackages = [
    # Due to heroic.
    "electron-24.8.6"
  ];

  # Include "An Anime Game Launcher".
  nix.settings.substituters = ["https://ezkea.cachix.org"];
  nix.settings.trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
}
