{ ... }: let
  initText = ''
    # Elixir IEx Persistent History.
    export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"

    # Make Elixir IEx Editor aware.
    export ELIXIR_EDITOR="nvim +__LINE__ __FILE__"
  '';
in {
  home.file.".iex.exs".text = ''
    IEx.configure([
      inspect: [pretty: true, charlists: :as_lists]
    ])
  '';

  programs.bash.initExtra = initText;
  programs.zsh.initExtraFirst = initText;
}
