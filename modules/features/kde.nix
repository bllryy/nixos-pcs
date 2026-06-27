{ self, inputs, ... }: {
  flake.nixosModules.kde = { pkgs, lib, ... }: {
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
