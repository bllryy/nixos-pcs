{ self, inputs, ... }: {
  flake.nixosModules.frameworkConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.frameworkHardware
      self.nixosModules.kde
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    networking.hostName = "framework";
    networking.networkmanager.enable = true;

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Framework-specific power management
    services.fwupd.enable = true;
    services.thermald.enable = true;
    powerManagement.cpuFreqGovernor = "powersave";

    users.users.user = { # change username
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "wireshark" ];
      shell = pkgs.bash;
    };

    environment.systemPackages = with pkgs; [
      chromium
      claude-code
      curl
      fastfetch
      fzf
      ghostty
      git
      go
      htop
      keepassxc
      mpv
      mullvad-vpn
      neovim
      nodejs
      obsidian
      openssh
      postman
      python3
      rustup
      signal-desktop
      telegram-desktop
      thunderbird
      tmux
      vesktop
      vim
      virt-manager
      wget
      wireguard-tools
      wireshark
    ];

    services.mullvad-vpn.enable = true;

    virtualisation.libvirtd.enable = true;

    programs.wireshark.enable = true;

    services.openssh.enable = true;

    system.stateVersion = "25.05";
  };
}
