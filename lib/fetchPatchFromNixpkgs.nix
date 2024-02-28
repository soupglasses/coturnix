{
  from,
  to,
  sha256,
}: (builtins.fetchurl {
  url = "https://github.com/NixOS/nixpkgs/compare/${from}...${to}.patch";
  inherit sha256;
})
