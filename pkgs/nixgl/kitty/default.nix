{ nixgl, symlinkJoin, makeWrapper, writeShellScriptBin, kitty }:
let
  wrapped = writeShellScriptBin "kitty" ''
    exec ${nixgl.nixGLIntel}/bin/nixGLIntel ${kitty}/bin/kitty "$@"
  '';
in symlinkJoin {
  name = "kitty";
  nativeBuildInputs = [ makeWrapper ];
  paths = [ wrapped kitty ];
}
