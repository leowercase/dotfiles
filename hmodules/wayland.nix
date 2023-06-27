{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.wayland;
  in
  {
    options.custom.wayland = {
      enable = mkEnableOption "Wayland";
    };

    config = mkIf cfg.enable {
      home.sessionVariables = {
        QT_QPA_PLATFORM = "wayland;xcb";
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland,x11";
      };
      xdg.configFile."electron-flags.conf".text = ''
        --enable-features=WaylandWindowDecorations
        --ozone-platform-hint=auto
      '';
    };
  }
