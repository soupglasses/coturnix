{pkgs, ...}: {
  imports = [
    ./hardware.nix

    ../desktop/modules/chromium.nix
    ../desktop/modules/spell.nix
    ../desktop/modules/desktops/gnome.nix
    ../desktop/modules/keyboard/interception.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "yoga";

  virtualisation.podman.enable = true; # For toolbox.
  virtualisation.libvirtd.enable = true; # For Boxes.

  services.telepathy.enable = true;

  services.guix.enable = true;

  services.onedrive.enable = true;

  programs.nix-ld.enable = true;

  programs.ns-usbloader.enable = true;

  # Do not disable touchpad when keyboard is used while gaming.
  programs.gamemode.settings.custom = {
    start = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false";
    end = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true";
  };
  #programs.gamemode.settings.gpu.amd_performance_level = "high";

  # Steam annoyingly does not follow normal scaling variables.
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "2";
  };

  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;
  users.users.sofi = {
    description = "Sofi";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd"];
  };

  # Firefox touchscreen support
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  environment.systemPackages = with pkgs; [
    firefox
    xclip
    gcc
    libreoffice
    alsaUtils
    spotify
    piper
    gimp
    foliate
    toolbox
    rnote
    wl-clipboard
    quintom-cursor-theme
    dino
    signal-desktop
    obsidian
    kitty
    krita
    gnome.polari

    # languages (simple)
    (python3.withPackages (p: with p; [ipython toolz more-itertools numpy sympy matplotlib]))
    nodejs

    # C++ Project Build Dependencies
    gcc
    gnumake
    cmake

    coturnix.steinwurf-tasker
  ];

  boot.binfmt.emulatedSystems = ["aarch64-linux" "i686-linux"];

  system.stateVersion = "23.05"; # No touch.
}
