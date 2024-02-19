# Coturnix

[Phenix](https://github.com/soupglasses/phenix)'s smaller sister, holding NixOS configurations for my personal machines.

> [!CAUTION]
> This repository is planned to be merged into [Phenix](https://github.com/soupglasses/phenix) at any moment. Do not import or otherwise rely on this repo to exist in any capacity, as it will be deleted without a grace period.
>
> Recommended action is to link against Phenix instead, or alternatively copy the revelant code snippets (with attribution as per the LICENSE file) directly.

## Future feature list

### Sync

- Filesync with Syncthing.

### Audio

- Use Pipewire to generate routable "groups".
  - Examples: "Multimedia", "Social", "Music", "Gaming".
  - Be able to enable/disable these for both speaker output, and choose them in OBS.
  - Autoconfigure things like Spotify, Discord, Element, Signal, Steam to follow these groupings.

### Firefox

- Firefox requires `privacy.webrtc.legacyGlobalIndicator` to be set to false.
  - Inspiration: <https://github.com/kurnevsky/nixfiles/blob/4708241e8506d622f89ee03dd8cdff71114eec3b/modules/firefox/firefox.nix>

- Firefox in a Firejail: <https://nixos.wiki/wiki/Firejail>
  - Alternatively, look into AppArmor. <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/apparmor/includes.nix>

### Networking

Figure out how to have a custom Wireguard VPN netns to link applications against.

### RAM

- Look into zswap.
  - Inspiration: <https://github.com/kurnevsky/nixfiles/blob/4708241e8506d622f89ee03dd8cdff71114eec3b/modules/zswap.nix>

## License

Copyright © https://github.com/soupglasses 2022-2024

This repository is licensed under the EUPL v1.2, with extension of article 5
(compatibility clause) to any licence for distributing derivative works that
have been produced by the normal use of the Work as a library.

For brevity, it can be likened to a "Lesser AGPLv3" license; however, this
is not legally binding advice. For a more comprehensive understanding of the
license, please refer to the attached [LICENSE](./LICENSE) file. Further
legal advice may be found at [JOINUP's pages on the EUPL](https://joinup.ec.europa.eu/collection/eupl).
