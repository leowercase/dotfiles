{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.suites.arts;
  in
  {
    options.my.suites.arts = {
      enable = mkEnableOption "the art suite";
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.krita ];
    };
  }
