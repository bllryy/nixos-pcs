{ ... }: {
  imports = [
    ./theme.nix
    ./niri.nix
    ./waybar.nix
    ./fuzzel.nix
    ./mako.nix
    ./swaylock.nix
    ./swayosd.nix
  ];

  home.username = "lily";
  home.homeDirectory = "/home/lily";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
