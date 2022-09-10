{ config, pkgs, lib, ... }: {
  # Automatically change hardcoded chrome paths to relative
  # paths in .desktop files.
  services.chrome-pwa.enable = true;

  environment.systemPackages = [ pkgs.chromium ];

  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
  ];
  programs.chromium.extraOpts = {
    WebAppInstallForceList = [
      {
        create_desktop_shortcut = true;
        default_launch_container = "window";
        url = "https://discord.com/channels/@me";
      }
      {
        create_desktop_shortcut = true;
        default_launch_container = "window";
        url = "https://app.element.io/";
      }
      {
        create_desktop_shortcut = true;
        default_launch_container = "window";
        url = "https://www.messenger.com/";
      }
    ];
    AlternativeBrowserPath = "${pkgs.firefox}/bin/firefox";
    AlternativeBrowserParameters = [ "--new-tab" "\${url}" ];
    BrowserSwitcherEnabled = true;
    BrowserSwitcherUrlGreylist = [
      "discord.com"
      "app.element.io"
      "messenger.com"
      "facebook.com"
    ];
    BrowserSwitcherUrlList = [ "*" ];
  };
}
