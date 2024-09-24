{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./atuin
    ./bat
    ./elixir
    ./fzf
    ./git
    ./gnome
    ./gpg
    ./navi
    ./starship
    ./zsh
    ./xdg
  ];

  # User side nix garbage collection for home-manager related generations.
  nix.enable = true;
  nix.package = pkgs.lix;
  nix.gc.automatic = true;
  nix.gc.frequency = "weekly";
  nix.gc.options = "--delete-older-than 21d";

  # Allow nix to configure `.profile` to let session variables be configured by nix.
  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    # Requirements
    home-manager
    # Cli
    asciinema
    ferium
    glow
    tealdeer
    tree
    trash-cli
    gh
    sd
    dig
    ripgrep
    rsync
    moreutils # vidir, etc.
    # Gui
    coturnix.nvim
    coturnix.steinwurf-tasker
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    PYTHONDONTWRITEBYTECODE = 1;
    VIRTUAL_ENV_DISABLE_PROMPT = 1;
    PYTHONBREAKPOINT = "ipdb.set_trace";
    CMAKE_C_COMPILER = "clang";
    CMAKE_CXX_COMPILER = "clang++";
    CMAKE_BUILD_TYPE = "Debug";
    CMAKE_GENERATOR = "Ninja";
    CMAKE_C_COMPILER_LAUNCHER = "ccache";
    CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
    CMAKE_C_LINKER_LAUNCHER = "mold;-run";
    CMAKE_CXX_LINKER_LAUNCHER = "mold;-run";
  };

  programs.dircolors.enable = true;

  home.shellAliases = {
    # Generic Commands
    tree = "tree --dirsfirst";
    ls = "ls --group --color=auto";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    ip = "ip -color";

    # Simpler Use
    open = "xdg-open";
    svim = "sudoedit";

    # QoL
    ipinfo = "ip -breif -color address";
    ping = "ping -c 5";
    ssh = "TERM=xterm-256color ssh";
    ssh-copy = "rsync -ah --info=progress2";
    rm = "rm -i";
    clear = "clear -x";

    # Shorthands
    c = "clear";
    q = "exit";
    py = "python";
    ipy = "ipython";
    lg = "lazygit";
    nr = "sudo nixos-rebuild --flake ${config.home.homeDirectory}/.coturnix";
    nrs = "nr switch";
    hm = "home-manager --flake ~/.coturnix#`whoami`";
    hms = "hm switch";
    k = "kubectl";
  };

  home.stateVersion = "21.11";
}
