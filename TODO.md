# The TODO list

This exists because I am forgetful and keep rediscovering things i want to do with my computer. :)

## Sync

- Filesync with Syncthing or Nextcloud.
  - I really want this to work offline with proper version mismatch solving.

## Audio

- Figure out how to use Pipewire/Pulseaudio to generate routable "groups".
  - For example, "Multimedia", "Social", "Music", "Gaming".
  - Be able to enable/disable these for both speaker output, and choose them in OBS.
  - Autoconfigure things like Spotify, Discord, Element, Signal, Steam to follow these groupings.

## Firefox

- Firefox requires `privacy.webrtc.legacyGlobalIndicator` to be set to false.
  - Inspiration: <https://github.com/kurnevsky/nixfiles/blob/4708241e8506d622f89ee03dd8cdff71114eec3b/modules/firefox/firefox.nix>

- Firefox in a Firejail: <https://nixos.wiki/wiki/Firejail>
  - Alternatively, look into AppArmor. <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/apparmor/includes.nix>

## Networking

Figure out how to have a custom Wireguard VPN netns to link applications against.

## RAM

Figure out zswap.
- Inspiration: <https://github.com/kurnevsky/nixfiles/blob/4708241e8506d622f89ee03dd8cdff71114eec3b/modules/zswap.nix>
