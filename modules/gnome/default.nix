{ lib, pkgs, ... }:
let
  inherit (lib.hm.gvariant) mkArray mkTuple type;
  mkStrArray = mkArray type.string;
in
{
  home.file.".face".source = builtins.fetchurl {
    url = "https://avatars.githubusercontent.com/u/20756843";
    sha256 = "sha256:0ciyqhqdr6il6y36b1n7p9d8s8cgb7hgih6dmj53lkb4hnnqsvqg";
  };

  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style.package = pkgs.adwaita-qt;
  qt.style.name = "adwaita-dark";

  home.packages = with pkgs; [
    adw-gtk3
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3";
    };
    "org/gnome/nautilus/preferences" = {
      search-filter-time-type = "last_modified";
    };
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "no+nodeadkeys" ]) ];
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = mkStrArray [ "lv3:ralt_switch" "nbsp:none" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      maximize = mkStrArray [ "<Super>w" ];
      unmaximize = mkStrArray [ "<Super>s" ];
      switch-windows = mkStrArray [ "<Alt>Tab" ];
      switch-windows-backward = mkStrArray [ "<Shift><Alt>Tab" ];
      switch-applications = mkStrArray [ ];
      switch-applications-backward = mkStrArray [ ];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = mkStrArray [ "<Super>a" ];
      toggle-tiled-right = mkStrArray [ "<Super>d" ];
    };
    "org/gnome/shell/keybindings" = {
      toggle-application-view = mkStrArray [ ];
      toggle-overview = mkStrArray [ ];
    };
  };
}
