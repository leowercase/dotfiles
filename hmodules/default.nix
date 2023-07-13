{ config, lib, username, myLib, overlays, pkgs, ... }:
  {
    imports = myLib.getModules ./.;

    # See https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "23.05";
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
    };

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;

    # Symlink $HOME/.config/home-manager to the flake
    xdg.configFile."home-manager".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos;

    nixpkgs = {
      config.allowUnfreePredicate = (_: true);
      overlays = [ overlays ];
    };

    home.packages = [ pkgs.xdg-utils ];
    xdg = {
      enable = true;
      # Lowercase user directories by default
      userDirs =
        {
          enable = true;
          createDirectories = true;
        }
        //
	(builtins.mapAttrs
          (_: dir: lib.mkDefault "${config.home.homeDirectory}/${dir}")
	  {
            desktop = "desktop";
            documents = "documents";
            download = "downloads";
            music = "music";
            pictures = "pictures";
            publicShare = "public";
            templates = "templates";
            videos = "videos";
          });
    };
  }
