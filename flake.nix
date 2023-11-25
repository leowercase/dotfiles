{
  description = "My NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, ... } @ flake:
    let
      lib = import ./lib nixpkgs.lib;

      systems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs systems;

      mkNvim = import ./neovim lib flake;
    in
    {
      # Lib
      lib = lib.custom;
      lib' = lib;

      # NixOS configurations
      nixosConfigurations = lib.custom.mkConfigurations {
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

      # NixVim
      inherit mkNvim;
      checks = forAllSystems (system: {
        nvim = nixvim.lib.${system}.check.mkTestDerivationFromNvim
          { inherit (self.packages.${system}) nvim; };
      });
      packages = forAllSystems (system: { nvim = mkNvim system; });
      apps = forAllSystems (system: {
        nvim = {
          type = "app";
          program = "${self.packages.${system}.nvim}/bin/nvim";
        };
      });
    };
}
