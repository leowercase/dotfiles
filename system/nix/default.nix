{ flake, ... }:
  {
    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs = {
      # Absolutely proprietary
      config.allowUnfree = true;

      overlays = [ (import ./overlay.nix) ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  }
