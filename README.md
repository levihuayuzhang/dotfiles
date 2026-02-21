# dotfiles

Using [GNU Stow](https://www.gnu.org/software/stow/) managing dotfiles on Arch Linux and MacOS.

> [!tip]
> Use `stow -t ~/ <module name>` to install links of dotfiles. (default target would be user home dir)

(for `rime-mac` see [rime-mac/README.md](rime-mac/README.md))

for nixos:
1. `stow -t / nixos`
2. run `sudo nixos-rebuild switch --flake /etc/nixos/flake#levi-pc`.

