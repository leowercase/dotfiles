{ config, options, lib, myLib, pkgs, ... }:
  with lib;
  let
    cfg = config.custom.desktop;
  in
  {
    imports = myLib.getModules ./.;
    
    options.custom.desktop = {
      init = mkOption {
	type = types.lines;
	default = "";
        description = "Initialization script for a graphical environment.";
      };

      env = mkOption {
	type = with types; attrsOf envVar;
        default = {};
	description = "Environment variables that should be present in a graphical environment.";
      };

      waylandIntegration = mkEnableOption "Wayland integration";
    };

    # See https://wiki.archlinux.org/title/Wayland#GUI_libraries
    config = mkIf cfg.waylandIntegration {
      custom.desktop.env = {
	NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
      
      home.packages = with pkgs; [
        libsForQt5.qt5.qtwayland
	qt6.qtwayland
      ];
    };
  }
