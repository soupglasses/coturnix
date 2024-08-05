{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "giturlparse";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wP/3whrMQ1SRsXeVZuA4dXogXB/9y0fk+B6lKtjDhZo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  meta = {
    changelog = "https://github.com/nephila/giturlparse/releases/tag/${version}";
    description = "Parse & rewrite git urls (supports GitHub, Bitbucket, Assembla ...)";
    homepage = "https://github.com/nephila/giturlparse/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [soupglasses];
  };
}
