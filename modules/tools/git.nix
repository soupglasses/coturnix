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
      sendemail = {
        smtpserver = "msmtp";
        smtpserveroption = "--account git";
        annotate = "yes";
      };
      # Performance
      core.fsmonitor = true;
      core.untrackedcache = true;

      # Delta
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      # Merging
      merge.tool = "nvimdiff";

      # Blame
      blame.coloring = "highlightRecent";
      blame.date = "relative";

      # -- General --

      # Cache credentials for an hour.
      credential.helper = "cache --timeout 3600";
      # Enable colors by default to interactive terminals.
      color.ui = "auto";
      # When initializing a new repository, use the better name `main` for the default branch.
      init.defaultbranch = "main";
      # Do not attempt to assume `user.email` and `user.name`, require these to be manually set.
      user.useConfigOnly = true;


      # -- Quality of Life --

      # When no upstream tracking exists, assume the `--set-upstream` option.
      push.autoSetupRemote = true;
      # Rebase branches on top of any fetched branches.
      pull.rebase = true;
      # Sort branches by last used instead of alphabetical order.
      branch.sort = "-committerdate";

      # -- Cryptographical Signatures --

      # Use a psuedo-default folder to find allowed ssh key signatures.
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      # Show signature information by default in `git log`.
      log.showSignature = true;
    };

    aliases = {
      # QoL
      aliases = "config --get-regexp alias";
      amend = "commit --amend";
      fix = "commit --amend --no-edit --date=now";
      force = "push --force-with-lease --force-if-includes";
      hist = "log --pretty='%C(auto)%h - %s %C(green)(%ar) %C(bold blue)<%an>%C(auto)%d' --graph --no-show-signature";
      main = "!git switch `git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4`";
      parts = "add --patch";
      rank = "shortlog --summary --numbered --no-merges";
      redate = "rebase --committer-date-is-author-date";
      root = "rev-parse --show-toplevel";
      unstage = "restore --staged";
      yeet = "push";
      yoink = "pull";
      # Shorthands
      po = "!git push origin `git branch --show-current`";
      st = "status --short --branch";
    };
  };
}
