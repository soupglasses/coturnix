# Home Manager

This is a [home-manager](https://github.com/nix-community/home-manager) configuration.

> Home manager provides a basic system for managing a user environment using the
> Nix package manager together with the Nix libraries found in Nixpkgs. It
> allows declarative configuration of user specific (non global) packages and
> dotfiles.
>
> [https://github.com/nix-community/home-manager](https://github.com/nix-community/home-manager)

[Go back to README](../README.md)

## Install

Now, I need to give you a warning before we continue. This configuration is
my own personal thing, so __do not simply copy-paste the next few commands__,
as it will likely result in colleral damage, error messages and headaches.

How I would instead recommend you to use this folder would be to copy files and
folders you are personally interested in, and feeding these into your
own home-manager configuration instead. But if you really want to use my exact
config, continue reading.

First you need to modify the [`flake.nix`](../flake.nix) file. In here there
will be a username you need to change to your own.

```
  homeConfigurations.sofi =
    ...
    home.username = "sofi";
```

I would recommend you to read through its manual first, and look over the files
in this folder to understand what they will do to your configuration.
The main change is that home-manager needs to be to hook into your bash shell.
Might sound scary at first, but you will just move your config file away from
it's install location, then use the `initExtra` option to import it back in.
Either using your shell's source command: `source PATH`. Or use
nix's builtin `builtins.readFile PATH` which will write your file's
contents into the generated file directly.

But once these changes are done, it should now be possible to run `nix-shell`.
It will install `nixUnstable` for flake support together with `home-manager`
for you. Once its complete, you can run:

```bash
$ home-manager switch --flake .
```

Congratulations, you are now home-manager'd!
