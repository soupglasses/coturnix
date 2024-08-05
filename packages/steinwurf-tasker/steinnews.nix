{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  colorama,
  click,
}:
buildPythonPackage rec {
  pname = "steinnews";
  version = "1.6.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "sha256-4ByLibEFCkUgyL0R0snxz+idFB95P7VqtenOqM4ibUU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    colorama
    click
  ];
}
