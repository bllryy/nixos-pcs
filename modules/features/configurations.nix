{ self, inputs, ... }: {
  flake.nixosConfigurations = {
    desktop = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        inputs.niri.nixosModules.niri
        self.nixosModules.common
        self.nixosModules.home
        self.nixosModules.desktop
        ../hosts/desktop/hardware-configuration.nix
      ];
    };
    framework = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        inputs.niri.nixosModules.niri
        self.nixosModules.common
        self.nixosModules.home
        self.nixosModules.framework
        ../hosts/framework/hardware-configuration.nix
      ];
    };
  };
}
