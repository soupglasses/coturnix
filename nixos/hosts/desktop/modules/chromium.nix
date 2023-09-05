{pkgs, ...}: {
  environment.systemPackages = [pkgs.chromium];

  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock Origin
    "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture in Picture
  ];

  # All options: https://chromeenterprise.google/policies
  programs.chromium.extraOpts = {
    # Websites to automatically install as PWAs on launch.
    # Manual update: Go to "chrome://apps" --> Right click changed app --> Press "Create shortcuts".
    WebAppInstallForceList = [
      {
        create_desktop_shortcut = true;
        default_launch_container = "window";
        url = "https://discord.com/channels/@me";
        custom_name = "Discord";
        custom_icon = {
          hash = "3077cf399bd25ca4490b58d4871f7a2eea230ae922fe596edee89213176676b3";
          url = "https://cdn3.iconfinder.com/data/icons/popular-services-brands-vol-2/512/discord-512.png";
        };
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
      {
        create_desktop_shortcut = true;
        default_launch_container = "window";
        url = "https://teams.microsoft.com/";
        custom_name = "Microsoft Teams";
        custom_icon = {
          hash = "c940ff7f01f9a1e80e5e127e9e77256472623955c8f9d09d9ab023e944a8bdb2";
          url = "https://statics.teams.cdn.office.net/hashed/favicon/prod/favicon-512x512-8d51633.png";
        };
      }
    ];

    # Open all other url's inside of Firefox, my preferred browser.
    AlternativeBrowserPath = "${pkgs.firefox}/bin/firefox";
    AlternativeBrowserParameters = ["--new-tab" "\${url}"];
    BrowserSwitcherEnabled = true;
    BrowserSwitcherUrlGreylist = [
      "pocketcasts.com"
      "discord.com"
      "app.element.io"
      "messenger.com"
      "facebook.com"
      "teams.microsoft.com"
      "login.microsoftonline.com"
      "aka.ms"
      "microsoft365.com"
      "adfs.srv.aau.dk"
      "signon.aau.dk"
    ];
    BrowserSwitcherUrlList = ["*"];

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
