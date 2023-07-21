{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.suites.desktop;
  in
  {
    options.my.suites.desktop = {
      enable = mkEnableOption "the desktop suite";
    };

    config = mkIf cfg.enable {
      my = {
        programs = {
	  qutebrowser.enable = true;
	  kitty.enable = true;
	};
      };

      home.packages = with pkgs; [
        tutanota-desktop
	discord

        noto-fonts
	noto-fonts-emoji
	noto-fonts-cjk-sans
	noto-fonts-cjk-serif
	(nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      custom.defaults = {
        programs = {
	  browser = "qutebrowser";
	  terminal = "kitty";
	};
	mimeApps.urls = "org.qutebrowser.qutebrowser.desktop";
	fonts = {
          serif = "Noto Serif";
          sansSerif = "Noto Sans";
          monospace = "FiraCode Nerd Font";
          emoji = "Noto Color Emoji";
	};
      };
    };
  }
