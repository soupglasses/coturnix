{ pkgs, config, inputs, ... }:
{
  home.packages = [ pkgs.comma ];
  programs.nix-index.enable = true;
  home.file."${config.xdg.cacheHome}/nix-index/files".source =
    inputs.nix-index-database.legacyPackages.${pkgs.hostPlatform.system}.database
      or inputs.nix-index-database.legacyPackages."x86_64-${pkgs.hostPlatform.parsed.kernel.name}".database;
}
