{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.leo.suites.desktop;
  in
  {
    options.leo.suites.desktop = {
      enable = mkEnableOption "the desktop suite";
    };

    config = mkIf cfg.enable {
      leo = {
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
