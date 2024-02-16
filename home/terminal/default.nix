{ ... }:
{
  imports = [
    ./bat
    ./comma
    ./elixir
    ./fzf
    ./git
    ./gpg
    ./navi
    ./starship
    ./zsh
    ./xdg
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    PYTHONDONTWRITEBYTECODE = 1;
    VIRTUAL_ENV_DISABLE_PROMPT = 1;
    PYTHONBREAKPOINT = "ipdb.set_trace";
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
    hm = "home-manager --flake ~/.dotfiles/home-manager";
    hms = "hm switch";
    k = "kubectl";
  };
}
