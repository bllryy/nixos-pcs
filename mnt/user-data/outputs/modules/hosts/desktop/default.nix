{ self, inputs, ... }: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      inputs.niri.nixosModules.niri
      self.nixosModules.common
      self.nixosModules.desktop
      ./hardware-configuration.nix
    ];
  };
}
