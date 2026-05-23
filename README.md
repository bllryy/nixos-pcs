# nixos-config

Framework laptop NixOS flake.

## Fresh install

1. Boot NixOS ISO, partition and mount disks at `/mnt`
2. `git clone <this repo>`
3. Edit `modules/hosts/framework/configuration.nix` — set username, timezone

## Rebuild on existing system

```bash
sudo nixos-rebuild switch --flake .#framework
```

## Structure

```
.
├── flake.nix
└── modules
    ├── hosts
    │   └── framework
    │       ├── default.nix          #
    │       ├── configuration.nix    
    │       └── hardware.nix         
    └── features
        └── kde.nix                  
```
# nixos-framework-13
