{ config, options, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.users'.leo.desktop;
  in
  {
    imports = custom.getModules'' ./.;
    
    options.users'.leo.desktop = {
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

      sound = {
        volumeLimit = mkOption {
          type = types.float;
          default = 1.0;
          description = "The upper limit of volume.";
        };
        initialVolume = mkOption {
          type = types.numbers.between 0 cfg.sound.volumeLimit;
          default = cfg.sound.volumeLimit / 3;
          description = "The initial volume percentage.";
        };
        initialMute = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to initially mute sound.";
        };
      };

      # Gulp
      swallow = {
        enable = mkEnableOption "window swallowing" // { default = true; };
        swallowables = mkOption {
          type = with types; listOf str;
          default = [];
          description = "A list of window titles that can be swallowed (usually terminals).";
        };
        exclude = mkOption {
          type = with types; listOf str;
          default = [];
          description = "A list of window titles that should not swallow.";
        };
      };
    };

    # See https://wiki.archlinux.org/title/Wayland#GUI_libraries
    config = mkIf cfg.waylandIntegration {
      users'.leo.desktop.env = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
      
      hm.leo.home.packages = with pkgs; [
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
      ];
    };
  }
