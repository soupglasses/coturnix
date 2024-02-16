{
  pkgs,
  lib,
  ...
}: {
  # Make chromium available to the system.
  environment.systemPackages = [pkgs.chromium];

  # Enable management of chromium policies.
  programs.chromium.enable = true;

  # Extensions to install.
  programs.chromium.extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock Origin
    "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture in Picture
    "jinjaccalgkegednnccohejagnlnfdag" # Violentmonkey
    "oocalimimngaihdkbihfgmpkcpnmlaoa" # Teleparty
  ];

  # Configure Chromium's Enterprise Policy Lists.
  # All options: https://chromeenterprise.google/policies
  programs.chromium.extraOpts = {
    # Websites to automatically install as PWAs.
    # Manual update: Go to "chrome://apps" --> Right click changed app --> Press "Create shortcuts".
    WebAppInstallForceList =
      lib.lists.forEach [
        {url = "https://app.element.io/";}
        {url = "https://www.messenger.com/";}
        {url = "https://www.netflix.com/";}
        {url = "https://play.pocketcasts.com/podcasts";}
        {
          url = "https://discord.com/channels/@me";
          custom_name = "Discord";
          custom_icon = {
            hash = "e94a1bb1fa28be712e5cb0068770bf9b139d4e6d0ee4cc097a668fedb2ad195d";
            url = "https://raw.githubusercontent.com/z-ffqq/Discord-BSD/853cfdd25f7f0b0dff3522863f84c2a4665a5e9b/assets/icon.png";
          };
        }
        {
          url = "https://teams.microsoft.com/";
          custom_name = "Microsoft Teams";
          custom_icon = {
            hash = "c940ff7f01f9a1e80e5e127e9e77256472623955c8f9d09d9ab023e944a8bdb2";
            url = "https://statics.teams.cdn.office.net/hashed/favicon/prod/favicon-512x512-8d51633.png";
          };
        }
        {
          url = "https://app.slack.com/client";
          custom_name = "Slack";
          custom_icon = {
            hash = "c7b09eff0344ff9431c2178226a9de226f940655a9a01b288670908f7b70fc32";
            url = "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Slack_icon_2019.svg/512px-Slack_icon_2019.svg.png";
          };
        }
        {
          url = "https://app.cinny.in";
          custom_name = "Cinny";
          custom_icon = {
            hash = "e0ed571a6b12aa33e6195b6f4a2443dc0aaebd40caffb63a68bb7988a57ce218";
            url = "https://app.cinny.in/public/android/android-chrome-512x512.png";
          };
        }
      ] (attr:
        attr
        // {
          create_desktop_shortcut = true;
          default_launch_container = "window";
        });

    # Open all other url's inside of Firefox, my preferred browser.
    AlternativeBrowserPath = "${pkgs.firefox}/bin/firefox";
    AlternativeBrowserParameters = ["--new-tab" "\${url}"];
    BrowserSwitcherEnabled = true;
    BrowserSwitcherUrlGreylist = [
      "cinny.in"
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
      "slack.com"
      "netflix.com"
      "teleparty.com"
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
