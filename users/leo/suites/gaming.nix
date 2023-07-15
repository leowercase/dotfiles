{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.suites.gaming;
  in
  {
    options.my.suites.gaming = {
      enable = mkEnableOption "the gaming suite";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        gamescope
      ];
    };
  }
