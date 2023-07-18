{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.suites.languages;
  in
  {
    options.my.suites.languages = {
      enable = mkEnableOption "the languages suite";
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.translate-shell ];
    };
  }
