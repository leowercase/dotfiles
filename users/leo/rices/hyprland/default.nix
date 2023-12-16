{ inputs, lib, config, pkgs, system, ... } @ args:
  with lib;
  let
    cfg = config.users'.leo.rices.hyprland;
  in
  {
    options.users'.leo.rices.hyprland = {
      enable = mkEnableOption "my Hyprland";
    };

    config = mkIf cfg.enable {
      users'.leo.desktop.hyprland = {
        enable = true;
        extraConfig = import ./config.nix args;
      };

      hm.leo.home.packages = with pkgs; [
	wl-clipboard
	libsForQt5.polkit-kde-agent

        rofi-wayland
        inputs.hyprland-contrib.packages.${system}.grimblast

        noto-fonts
	noto-fonts-emoji
	noto-fonts-cjk-sans
	noto-fonts-cjk-serif
	(nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      users'.leo.fonts.aliases = {
        serif = "Noto Serif";
        sans-serif = "Noto Sans";
        monospace = "FiraCode Nerd Font";
        emoji = "Noto Color Emoji";
      };

      users'.leo.programs = {
        swaylock-effects.enable = true;

        swayidle = {
          enable = true;
          screenLocker = "${pkgs.swaylock-effects}/bin/swaylock";
        };
      };

      hm.leo.services.dunst = {
        enable = true;
      };
    };
  }
