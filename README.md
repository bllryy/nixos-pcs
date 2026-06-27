# nixos-framework-13

NixOS config for Framework 13 laptop and desktop. Niri + KDE.

## Install

```
git clone https://github.com/bllryy/nixos-framework-13.git
cd nixos-framework-13
chmod +x install.sh
./install.sh            # auto-detects host via DMI
./install.sh framework  # or specify
./install.sh desktop
```

The script generates `modules/hosts/<host>/hardware-configuration.nix` on first run, then runs `nixos-rebuild switch --flake .#<host>`.

## Layout

```
modules/
  features/
    common.nix      shared config (user, packages, locale, desktop imports)
    kde.nix         KDE Plasma + SDDM
    niri.nix        niri + sddm + pipewire + portals
    framework.nix   laptop: fwupd, fprintd, power-profiles
    desktop.nix     desktop-specific
  hosts/
    framework/      hardware-configuration.nix generated on install
    desktop/        hardware-configuration.nix generated on install
```
