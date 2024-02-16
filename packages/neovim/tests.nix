{ fetchFromGitLab, runCommandLocal, writeText, perl, neovim-drv }: let
  nmt = fetchFromGitLab {
    owner = "rycee";
    repo = "nmt";
    rev = "d2cc8c1042b1c2511f68f40e2790a8c0e29eeb42";
    sha256 = "1ykcvyx82nhdq167kbnpgwkgjib8ii7c92y3427v986n2s5lsskc";
  };
  runTest = neovim-drv: buildCommand:
    runCommandLocal "test-${neovim-drv.name}" {
      nativeBuildInputs = [];
      meta.platforms = neovim-drv.meta.platforms;
    } (''
        source ${nmt}/bash-lib/assertions.sh
        vimrc="${writeText "init.vim" neovim-drv.initRc}"
        vimrcGeneric="$out/patched.vim"
        mkdir $out
        ${perl}/bin/perl -pe "s|\Q$NIX_STORE\E/[a-z0-9]{32}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" < "$vimrc" > "$vimrcGeneric"
      ''
      + buildCommand);
in {
  sanity = runTest neovim-drv ''
    export HOME=$TMPDIR
    ${neovim-drv}/bin/nvim -i NONE +quit! -e
  '';
}
