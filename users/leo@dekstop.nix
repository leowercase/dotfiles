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
    home.packages = with pkgs; [
      mindustry-wayland
      translate-shell
    ];
  }
