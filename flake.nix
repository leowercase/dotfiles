{
  description = "My NixOS Flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    nixos-hardware.url = github:nixos/nixos-hardware;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = github:hyprwm/contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = github:nix-community/nixvim;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = flake:
    let
      myLib = import ./lib flake;
    in
    myLib.mkFlake ./. {
      dekstop = "x86_64-linux";
      latpop = "x86_64-linux";
    };
}
