{config, ...}:
{
  home.sessionVariablesExtra = ''
    # Add user installed software to PATH.
    export PATH="${config.home.homeDirectory}/.local/bin:$PATH"
    # WORKAROUND: https://github.com/nix-community/home-manager/issues/2751
    export EDITOR="$VISUAL";
  '';
}
