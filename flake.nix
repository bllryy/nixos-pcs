{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    niri.url = "github:sodiboo/niri-flake";
    home-manager = {
      url = "https://github.com/nix-community/home-manager/archive/refs/heads/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./modules/features/common.nix
        ./modules/features/kde.nix
        ./modules/features/niri.nix
        ./modules/features/framework.nix
        ./modules/features/desktop.nix
        ./modules/features/home.nix
        ./modules/features/configurations.nix
      ];
    };
}
