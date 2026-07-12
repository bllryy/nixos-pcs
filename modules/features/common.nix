{ self, inputs, ... }: {
  flake.nixosModules.common = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.kde
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    nixpkgs.config.allowUnfree = true;

    users.users.lily = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" ];
      shell = pkgs.zsh;
    };
    programs.zsh.enable = true;

    fonts.packages = with pkgs; [ nerd-fonts.iosevka ];

    environment.systemPackages = with pkgs; [
      git vim neovim wget curl
      firefox kitty alacritty
      brightnessctl playerctl vesktop signal-desktop
      tree fd fzf tmux jq unzip btop fastfetch mpv
      go nodejs python3 gcc cmake pkg-config libtool gtk4
      claude-code codex vscode jetbrains.idea
      keepassxc kdePackages.dolphin filezilla obs-studio
      pavucontrol ungoogled-chromium
      (prismlauncher.override { additionalLibs = [ libxtst ]; })
      appimage-run hyfetch rustdesk libinput waywall gnumake
    ];

    programs.nix-ld.enable = true;
    programs.steam.enable = true;
    services.flatpak.enable = true;
    services.tailscale.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;

    system.stateVersion = "26.05";
  };
}
