{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gh
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userEmail = "sofi+git@mailbox.org";
    userName = "Sofi";
    signing.key = "1B2722AF";

    signing.signByDefault = true;

    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        navigate = "true";
        line-numbers = "true";
        light = "false";
        theme = "OneHalfLight";
        features = "interactive";
      };
    };

    extraConfig = {
      # Performance
      core.fsmonitor = true;
      core.untrackedcache = true;

      # Delta
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      blame.coloring = "highlightRecent";
      blame.date = "relative";
      branch.autosetupmerge = "true";
      credential.helper = "cache --timeout 3600";
      color.ui = "true";
      init.defaultbranch = "main";
      pull.rebase = "true";
      tag.gpgsign = "true";
      tag.forcesignannotated = "true";

      sendemail = {
        smtpserver = "/usr/bin/msmtp";
        smtpserveroption = "--account git";
        annotate = "yes";
      };
    };

    aliases = {
      # QoL
      hist = "log --pretty='%C(auto)%h - %s %C(green)(%ar) %C(bold blue)<%an>%C(auto)%d' --graph";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
      # Shorthands
      co = "checkout";
      br = "branch";
      st = "status --short --branch";
    };
  };
}
