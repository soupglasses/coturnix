{
  lib,
  nix,
  python3Packages,
}:
python3Packages.buildPythonPackage {
  pname = "genpatch";
  version = "0.0.1";
  pyproject = true;

  build-system = with python3Packages; [setuptools-scm];

  src = ./src;
  propagatedBuildInputs = [nix];

  meta = with lib; {
    description = "Generate locked fetchurl patches of nixpkgs prs";
    license = licenses.eupl12;
    maintainers = with maintainers; [soupglasses];
  };
}
