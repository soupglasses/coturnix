{config, ...}: {
  imports = [
    ./env.nix
    ./git.nix
  ];

  # Allow nix to deal with system paths outside of nix when managed by home-manager.
  targets.genericLinux.enable = true;

  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.config = ["/etc/xdg"];
  xdg.systemDirs.data = [
    "/usr/local/share"
    "/usr/share"
    "/var/lib/flatpak/exports/share"
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];

  home.sessionVariablesExtra = ''
    # WORKAROUND: https://github.com/nix-community/home-manager/issues/1439
    export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
  '';
}
