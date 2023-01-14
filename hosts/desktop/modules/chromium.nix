{ config, pkgs, lib, ... }: {
  # Automatically change hardcoded chrome paths to relative
  # paths in .desktop files.
  services.chrome-pwa.enable = true;

  environment.systemPackages = [ pkgs.chromium ];

  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock Origin
    "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture in Picture
  ];

  # All options: https://chromeenterprise.google/policies
  programs.chromium.extraOpts = {

    # Websites to automatically install as PWAs on launch.
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
      {
        create_desktop_shortcut = true;
        default_launch_container = "window";
        fallback_app_name = "Pocket Casts";
        url = "https://play.pocketcasts.com/podcasts";
      }
    ];

    # Open all other url's inside of Firefox, my prefered browser.
    AlternativeBrowserPath = "${pkgs.firefox}/bin/firefox";
    AlternativeBrowserParameters = [ "--new-tab" "\${url}" ];
    BrowserSwitcherEnabled = true;
    BrowserSwitcherUrlGreylist = [
      "pocketcasts.com"
      "discord.com"
      "app.element.io"
      "messenger.com"
      "facebook.com"
    ];
    BrowserSwitcherUrlList = [ "*" ];

    # Privacy Tweaks.
    CloudReportingEnabled = false;
    MetricsReportingEnabled = false;
    SafeBrowsingExtendedReportingEnabled = false;

    # General tweaks.
    BookmarkBarEnabled = false;
    BrowserGuestModeEnabled = false;
    HttpsOnlyMode = "force_enabled";
    PasswordManagerEnabled = false;
  };
}
