{ pkgs, ... }:
  {
    my = {
      suites = {
        dev.enable = true;
	desktop.enable = true;
	gaming.enable = true;
      };
      desktop.hyprland.enable = true;
    };
    home.packages = [ pkgs.mindustry-wayland ];
  }
