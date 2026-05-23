{ self, inputs, ... }: {
  flake.nixosConfigurations.framework = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.frameworkConfiguration
    ];
  };
}
