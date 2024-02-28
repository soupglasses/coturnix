{
  writeShellScriptBin,
  curl,
  jq,
  nix,
}:
writeShellScriptBin "genpatch" ''
  set -euo pipefail
  # Weakness: The API returns the commit for the current upstream you are merging
  # to. If the patch gets merge conflicts, this will also break. Haven't found an
  # easy way to get the "true" parent commit for the PR.

  if [ $# -eq 0 ]; then
    echo "No PR number supplied"
    exit 1
  fi

  repo="NixOS/nixpkgs"
  pr_number=$1

  response=$(${curl}/bin/curl -s "https://api.github.com/repos/$repo/pulls/$pr_number")

  latest_commit=$(echo $response | ${jq}/bin/jq -r '.head.sha')
  base_commit=$(echo $response | ${jq}/bin/jq -r '.base.sha')
  last_updated_at=$(echo $response | ${jq}/bin/jq -r '.updated_at')

  patch_url="https://github.com/NixOS/nixpkgs/compare/$base_commit...$latest_commit.patch"
  sha256_sum=$(${nix}/bin/nix-prefetch-url --quiet $patch_url)

  pr_title=$(echo $response | ${jq}/bin/jq -r '.title')
  cat << EOF
  # $pr_title [''${last_updated_at:0:10}] - https://nixpk.gs/pr-tracker.html?pr=$pr_number
  (self.lib.fetchPatchFromNixpkgs {
    from = "$base_commit";
    to = "$latest_commit";
    sha256 = "$sha256_sum";
  })
  EOF
''
