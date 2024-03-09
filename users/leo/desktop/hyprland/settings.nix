{ pkgs, config, ... }:
  # See https://wiki.hyprland.org/ for information
  {
    exec-once = [
      "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      "wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%"
      "swww init"
      "swww img ${config.users'.leo.wallpaper}"
    ];

    general = {
      layout = "master";
      gaps_in = 5;
      gaps_out = 10;

      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      cursor_inactive_timeout = 10;
    };

    animations = {
      enabled = true;
      animation = [
        "windows, 1, 7, default"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    decoration = {
      rounding = 10;
    };

    master = {
      new_is_master = true;
    };

    misc = {
      force_default_wallpaper = 0;
      disable_splash_rendering = true;
      vrr = 1;
    };

    # See https://wiki.archlinux.org/title/Wayland#GUI_libraries
    env = [
      "NIXOS_OZONE_WL, 1"
      "QT_QPA_PLATFORM, wayland;xcb"
      "SDL_VIDEODRIVER, wayland,x11"
      "CLUTTER_BACKEND, wayland"
      "_JAVA_AWT_WM_NONREPARENTING, 1"
    ];
  }
