{ inputs, ... }:
  {
    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs = {
      # Absolutely proprietary
      config.allowUnfree = true;

      overlays = [ (import ./overlay.nix) ];
    };

    # Custom Nix system registry entries. This allows me to, for example,
    # run `nix run dotfiles#nvim` instead of `nix run github:leowercase/dotfiles#nvim`
    nix.registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inputs.nixpkgs;
      };

      dotfiles = {
        from = {
          id = "dotfiles";
          type = "indirect";
        };
        flake = inputs.self;
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  }
