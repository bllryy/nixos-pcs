{ self, inputs, ... }: {
  flake.nixosModules.kde = { pkgs, ... }: {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.xserver.enable = true;

    hardware.graphics.enable = true;

    xdg.portal.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
