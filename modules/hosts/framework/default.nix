{ self, inputs, ... }: {
  flake.nixosConfigurations.framework = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      inputs.niri.nixosModules.niri
      self.nixosModules.frameworkConfig
      ../../../hardware-configuration.nix
    ];
  };
}
