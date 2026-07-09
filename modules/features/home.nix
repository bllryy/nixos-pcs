{ self, inputs, ... }: {
  flake.nixosModules.home = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = { inherit inputs self; };
      # niri's typed KDL settings (programs.niri.settings) are auto-injected into
      # home-manager by inputs.niri.nixosModules.niri, so no extra import here.
      users.lily = import ../../home;
    };
  };
}
