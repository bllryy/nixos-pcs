#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HW_FILE="$REPO_DIR/modules/hosts/framework/hardware-configuration.nix"

if [ ! -f "$HW_FILE" ]; then
  echo "copying hardware-configuration.nix from /etc/nixos"
  sudo cp /etc/nixos/hardware-configuration.nix "$HW_FILE"
  sudo chown "$USER:users" "$HW_FILE"
fi

sudo nixos-rebuild switch --flake "$REPO_DIR#framework"
