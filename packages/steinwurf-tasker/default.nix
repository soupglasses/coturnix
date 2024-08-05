{
  callPackage,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  invoke,
  fabric,
  invocations,
  semver,
  PyGithub,
  decorator,
}: let
  giturlparse = callPackage ./giturlparse.nix {};
  steinnews = callPackage ./steinnews.nix {};
in
  buildPythonPackage rec {
    pname = "steinwurf-tasker";
    version = "2.0.3";
    format = "wheel";

    src = fetchPypi {
      pname = "steinwurf_tasker";
      inherit version;
      format = "wheel";
      sha256 = "sha256-DBYwfd9FYB10xSeveta83w4lUYzJGahyQQsxnDqu+uM=";
    };

    build-system = [
      setuptools
      setuptools-scm
    ];

    dependencies = [
      invoke
      fabric
      invocations
      giturlparse
      semver
      steinnews
      PyGithub
      decorator
    ];

    meta.mainProgram = "sw";
  }
