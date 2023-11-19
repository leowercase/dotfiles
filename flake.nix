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

  outputs = { nixpkgs, ... } @ flake:
    with import ./lib nixpkgs.lib;
    {
      nixosConfigurations = custom.mkConfigurations {
        inherit nixpkgs;
        hosts = {
          dekstop = {
            system = "x86_64-linux";
            modules = [ ./modules/hosts/dekstop.nix ];
          };
          latpop = {
            system = "x86_64-linux";
            modules = [ ./modules/hosts/latpop.nix ];
          };
        };
        modules = [ ./modules/system ./modules/users ];
        specialArgs = { inherit flake; };
      };
    };
}
