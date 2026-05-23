{ self, inputs, ... }: {
  # Replace this entire file with the output of:
  # nixos-generate-config --show-hardware-config
  flake.nixosModules.frameworkHardware = { ... }: {
    imports = [ ];

    # Paste hardware-configuration.nix contents here
  };
}
