{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.fonts;
  in
  {
    options.my.fonts = {
      enable = mkEnableOption "my fonts";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      custom.fonts = {
        serif = "Noto Serif";
        sansSerif = "Noto Sans";
        monospace = "FiraCode Nerd Font";
        emoji = "Noto Color Emoji";
      };
    };
  }
