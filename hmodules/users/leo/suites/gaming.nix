{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.leo.suites.gaming;
  in
  {
    options.leo.suites.gaming = {
      enable = mkEnableOption "the gaming suite";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        gamescope
      ];
    };
  }
