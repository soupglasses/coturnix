{config, lib, ...}: {
  xdg.enable = true;

  # File produced by following `xdg-ninja`'s output.

  home.sessionVariables = {
    _JAVA_OPTIONS= "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    ANDROID_HOME="$XDG_DATA_HOME/android";
    CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv";
    GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
    IPYTHONDIR="$${XDG_CONFIG_HOME}/ipython";
    JULIA_DEPOT_PATH= "$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH";
    PYTHONSTARTUP="$${XDG_CONFIG_HOME}/python/pythonrc";
    SQLITE_HISTORY = "$XDG_CACHE_HOME/sqlite_history";
    WINEPREFIX = "$XDG_DATA_HOME/wine";
    XCOMPOSECACHE = "$${XDG_CACHE_HOME}/X11/xcompose";
    ZDOTDIR = "$HOME/.config/zsh";
  };

  home.shellAliases = {
    wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
  };

  home.file."${config.xdg.configHome}/python/pythonrc".text = ''
    import os
    import atexit
    import readline

    history = os.path.join(os.environ['XDG_CACHE_HOME'], 'python_history')
    try:
        readline.read_history_file(history)
    except OSError:
        pass

    def write_history():
        try:
            readline.write_history_file(history)
        except OSError:
            pass

    atexit.register(write_history)
  '';

  home.file.".npmrc".text = ''
    prefix=''${XDG_DATA_HOME}/npm
    cache=''${XDG_CACHE_HOME}/npm
    tmp=''${XDG_RUNTIME_DIR}/npm
    init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
  '';

  # Zsh config, plugins, history.
  programs.zsh.dotDir = ".config/zsh";
  programs.zsh.history.path = "$ZDOTDIR/.zsh_history";
  home.file.".zshenv".enable = false;
}
