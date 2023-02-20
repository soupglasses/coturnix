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
    signing.key = "7A3B361F";

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

      merge.tool = "nvimdiff";

      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      log.showSignature = true;

      blame.coloring = "highlightRecent";
      blame.date = "relative";
      branch.autosetupmerge = true;
      credential.helper = "cache --timeout 3600";
      color.ui = true;
      init.defaultbranch = "main";
      pull.rebase = true;
      tag.gpgsign = true;
      tag.forcesignannotated = true;
      user.useConfigOnly = true;

      sendemail = {
        smtpserver = "/usr/bin/msmtp";
        smtpserveroption = "--account git";
        annotate = "yes";
      };
    };

    aliases = {
      # QoL
      aliases = "config --get-regexp alias";
      amend = "commit --amend";
      fix = "commit --amend --no-edit --date=now";
      force = "push --force-with-lease --force-if-includes";
      hist = "log --pretty='%C(auto)%h - %s %C(green)(%ar) %C(bold blue)<%an>%C(auto)%d' --graph --no-show-signature";
      parts = "add --patch";
      rank = "shortlog --summary --numbered --no-merges";
      redate = "rebase --committer-date-is-author-date";
      unstage = "restore --staged";
      # Shorthands
      po = "!git push origin `git branch --show-current`";
      st = "status --short --branch";
    };
  };
}
