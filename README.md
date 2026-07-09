# nixos-pcs

NixOS config for a Framework 13 laptop and a desktop. Niri (+ KDE Plasma as an
alternate session), nvim, home-manager-managed niri rice.

## Install (either machine)

```
git clone https://github.com/bllryy/nixos-pcs.git
cd nixos-pcs
chmod +x install.sh
./install.sh            # auto-detects framework vs desktop via DMI
```

Or force a host: `./install.sh framework` / `./install.sh desktop`.

First run generates `modules/hosts/<host>/hardware-configuration.nix` (gitignored,
machine-specific), then runs `nixos-rebuild switch --flake .#<host>`.

## Rebuild later

```
sudo nixos-rebuild switch --flake .#framework
sudo nixos-rebuild switch --flake .#desktop
```

## niri keybinds (Mod = Super)

```
Mod+Return            terminal (kitty)          Mod+Q            close window
Mod+Space / Ctrl+Space / Mod+D   launcher (fuzzel)
Mod+H/J/K/L           focus col / window        Mod+Shift+HJKL   move window
Mod+Ctrl+J/K          move column to workspace  Mod+Alt+J/K      switch workspace
Mod+1..9              focus workspace           Mod+R            cycle preset widths
Mod+F / Mod+Shift+F   maximize / fullscreen     Mod+-/=          resize column
Mod+Alt+L             lock                       Mod+Shift+E      power menu
Mod+S / Print         region screenshot         Mod+Slash        searchable keybind list
```

Caps Lock is remapped to Escape. Media/brightness keys show an on-screen bar (swayosd).
Idle-locks after 5 min and before sleep. The `keys` command (or Mod+Slash) prints the
live keybind list.

## Theme

The whole niri desktop is colored from `home/theme.nix`. Swap `variant = "blood"`
to `"macchiato"` there to retheme everything (bar, launcher, notifications, lock).
Wallpaper is a solid palette color via swaybg; point `spawn-at-startup` in
`home/niri.nix` at an image (`swaybg -i /path -m fill`) for a picture instead.

## Layout

```
flake.nix                     inputs + registers feature modules
modules/
  features/
    common.nix                shared: user, packages, locale, imports kde+niri
    kde.nix                   KDE Plasma + SDDM
    niri.nix                  niri compositor + sddm + pipewire + portals
    framework.nix             laptop: fwupd, fprintd, power-profiles
    desktop.nix               desktop hostname
    home.nix                  home-manager wiring (user: lily)
    configurations.nix        nixosConfigurations.{desktop,framework}
  hosts/{desktop,framework}/  hardware-configuration.nix generated on install
home/                         home-manager: niri rice (borrowed from vmfunc/nixfiles)
  niri.nix waybar.nix fuzzel.nix mako.nix swaylock.nix swayosd.nix theme.nix
```
