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
	};
      };

      home.packages = with pkgs; [
        tutanota-desktop # Email provider
	discord
      ];

      home.sessionVariables = {
        BROWSER = "qutebrowser";
      };
    };
  }
