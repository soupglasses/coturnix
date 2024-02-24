# Nix

[Go back to README](../README.md)

## What is Nix?

> Nix is a cross-platform package manager that utilizes a purely functional
> deployment model where software is installed into unique directories generated
> through cryptographic hashes. It is also the name of the tool's programming
> language. A package's hash takes into account the dependencies, which is
> claimed to eliminate dependency hell.[2] This package management model
> advertises more reliable, reproducible, and portable packages.
>
> [https://en.wikipedia.org/wiki/Nix_(package_manager)](https://en.wikipedia.org/wiki/Nix_(package_manager))

## Installation

You will need a reasonably up to date nix install. I have attempted to make
this script as backwards compatible as possible.

### Install Nix - Recommended method

I recommend you use a distribution-spessific package for Nix. As it is currently
more up to date than the official methods for installing Nix. Plus it ships with
extra helpers to get nix running nicely under non-NixOS environments.
This is especially true for SELinux-enabled distros like Fedora and CentOS.

Follow the steps:
[https://nix-community.github.io/nix-installers/](https://nix-community.github.io/nix-installers/).

In short, it would be to run the command below, swapping out with your package
manager of choice:

```bash
$ sudo dnf install ~/Downloads/nix-multi-user-x.x.x.rpm
```

You can safely ignore any warnings about `nixbld` accounts. It is just informing
you that nix is creating its nix-build accounts. These get removed when you run
`sudo dnf remove nix-multi-user`.

#### Note on Fedora/CentOS

If you are running on Fedora/CentOS, i can also recommend making this file to
let `nixpkgs`'s version of OpenSSH to work without errors.

```bash
# /etc/ssh/ssh_config.d/10-nixpkgs-support.conf
Match all
    IgnoreUnknown "rsaminsize,gssapikexalgorithms"
```

### Install Nix - Official method

If you cannot follow the method above, maybe due to running an exotic
operating system that is not packaged above, you can follow the
official instructions here:
[https://nixos.org/download.html](https://nixos.org/download.html).

Do be warned, this is a `.sh` script you run as root! It may mess up your system!

Once installed you will need to add this line into `~/.config/nix/nix.conf`,
or `/etc/nix/nix.conf` if you want it to be system-wide.

```bash
# ~/.config/nix/nix.conf
experimental-features = nix-command flakes
```

This will give you access to the modern `nix` commands (`nix build`/`nix run`),
together with the `nix flake` subset of commands, which are for `flake.nix` and
`flake.lock` files.

## How Nix Functions

Nix downloads all its binaries to a location called `/nix/store`. So do not be
afraid if you want to run packages you already have installed. Nix will not
touch your normal system install.

For example, you can run htop from `nixpkgs`, the default repository for nix
packages.

```
nix run nixpkgs#htop`
```

Now watch closely, as you can watch it download `htop` as well as any dependencies
it will need.

TODO

`nix develop`

`nix build`

`nix build -L`

https://myme.no/posts/2022-01-16-nixos-the-ultimate-dev-environment.html#the-elevator-pitch

`.#`

Direnv

`nix profile`

nixpkgs search

## Maintinence

TODO.

```bash
# Show all weakly-linked GC-roots (f.x. result folders that should be manually deleted).
ls -l /nix/var/nix/gcroots/auto/

# Remove all home-manager generations
home-manager expire-generations "-14 days"

# Remove all previous profile generations.
nix profile wipe-history

# Garbage collect all non GC-root derivations.
nix-collect-garbage
```
Or if you would like a quick "delete all" that will capture the worst offenders without having to worry too much:
```bash
# Unlink all previous generations and garbage collect (a handy all-in-one command).
nix-collect-garbage -d
# Clean up boot entries in systemd-boot/grub2.
/run/current-system/bin/switch-to-configuration boot
```

## Recommended reading:

If you are new to Nix, i highly recommend you to spend an hour reading up on
the topic. As it is wildly different from package managers that you are used
to. If you want to avoid mistakes, and learn how to keep your Nix Store so that
it won't start to eat up all the space on your computer? I can recommend reading
about it now, and not learn about it later.

"Nix in my development workflow" is a great introduction for those who just
want to get to up to speed with practically using nix.

Do keep in mind that we are using home-manager to manage packages, and not
`nix-env -i`. Plus, upgrades are handled with flakes `nix flake update` instead
of `nix-channel --update`.

[https://medium.com/@ejpcmac/about-using-nix-in-my-development-workflow-12422a1f2f4c](https://medium.com/@ejpcmac/about-using-nix-in-my-development-workflow-12422a1f2f4c)

### Further reading

Then for those who are more interested in learning about Nix, i would recommend
also looking at this meta resource with everything you should need to know:
[https://github.com/nix-community/awesome-nix](https://github.com/nix-community/awesome-nix).
