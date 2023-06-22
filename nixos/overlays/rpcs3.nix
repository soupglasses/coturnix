final: prev: {
  rpcs3 = prev.rpcs3.overrideAttrs (_old: let
    rpcs3GitVersion = "15225-715e3856f";
    rpcs3Version = "0.0.28-15225-715e3856f";
    rpcs3Revision = "715e3856f224f4407080227d0ad6076a4ba657a1";
    rpcs3Sha256 = "0ql7hpzz96s1yyiigb3n8pnh108s38dxxyxmx9gzadg196b66w8n";
  in {
    version = rpcs3Version;
    src = final.fetchFromGitHub {
      owner = "RPCS3";
      repo = "rpcs3";
      rev = rpcs3Revision;
      fetchSubmodules = true;
      sha256 = rpcs3Sha256;
    };
    preConfigure = ''
      cat > ./rpcs3/git-version.h <<EOF
      #define RPCS3_GIT_VERSION "${rpcs3GitVersion}"
      #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
      #define RPCS3_GIT_BRANCH "HEAD"
      #define RPCS3_GIT_VERSION_NO_UPDATE 1
      EOF
    '';
    patches = [
      ./0001-llvm-ExecutionEngine-IntelJITEvents-only-use.patch
      ./0001-update.patch
    ];
  });
}
