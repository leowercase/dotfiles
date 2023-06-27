{
  description = "My NixOS Flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.05;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;

    nixos-hardware.url = github:nixos/nixos-hardware;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = github:hyprwm/Hyprland;
    hyprland-contrib = {
      url = github:hyprwm/contrib;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = flake:
    let
      myLib = import ./lib flake;
    in
    myLib.mkFlake ./. {
      dekstop = {
        system = "x86_64-linux";
        hmUsers = [ "leo" ];
      };
      latpop = {
        system = "x86_64-linux";
        hmUsers = [ "leo" ];
      };
    };
}
