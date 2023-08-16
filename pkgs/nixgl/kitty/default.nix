{ nixgl, symlinkJoin, makeWrapper, writeShellScriptBin, kitty }:
let
  wrapped = writeShellScriptBin "kitty" ''
    exec ${nixgl.nixGLIntel}/bin/nixGLIntel ${kitty}/bin/kitty -o env=LIBVA_DRIVERS_PATH -o env=LIBGL_DRIVERS_PATH -o env=LD_LIBRARY_PATH -o env=__EGL_VENDOR_LIBRARY_FILENAMES -o env=VK_LAYER_PATH -o env=VK_ICD_FILENAMES "$@"
  '';
in symlinkJoin {
  name = "kitty";
  nativeBuildInputs = [ makeWrapper ];
  paths = [ wrapped kitty ];
}
