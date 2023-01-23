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
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvSBEh5IcFvQ6rrh5awQ+LljV8i1j81Q3jZAWhRSo+D";

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

      # GPG ssh signing
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

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
