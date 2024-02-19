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

### Usage of Compatible Licences

_Please note that the advice in this section is for reference purposes only and
does not constitute legal advice._

The Source Code from this repository can be both utilized and modified under the EUPL v1.2
license, or alternatively, according to Article 5 of the EUPL, you have the option to select
any of the EUPLv1.2's 'Compatible Licences'. These have been listed at the end of this section
for convenience.

Additionally, with the above license extension to Article 5 (compatibility clause) for this Work,
you are further allowed the use this repository as a library with a project with ___any license___,
including complete linking freedom.

| License                                                   | Shorthand     | Applicable Version(s)                    |
|-----------------------------------------------------------|---------------|------------------------------------------|
| GNU General Public License                                | GPL           | v. 2, v. 3                               |
| GNU Affero General Public License                         | AGPL          | v. 3                                     |
| Open Software License                                     | OSL           | v. 2.1, v. 3.0                           |
| Eclipse Public License                                    | EPL           | v. 1.0                                   |
| CeCILL                                                    | CECILL        | v. 2.0, v. 2.1                           |
| Mozilla Public Licence                                    | MPL           | v. 2                                     |
| GNU Lesser General Public Licence                         | LGPL          | v. 2.1, v. 3                             |
| Creative Commons Attribution-ShareAlike                   | CC BY-SA      | v. 3.0 Unported (for non-software works) |
| European Union Public Licence                             | EUPL          | v. 1.1, v. 1.2                           |
| Québec Free and Open-Source Licence — Reciprocity         | LiLiQ-R       | -                                        |
| Québec Free and Open-Source Licence — Strong Reciprocity  | LiLiQ-R+      | -                                        |
