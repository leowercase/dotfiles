{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.programs.btop;
  in
  {
    options.my.programs.btop = {
      enable = mkEnableOption "my btop";
    };

    config = mkIf cfg.enable {
      programs.btop = {
        enable = true;
	settings.vim_keys = true;
      };
    };
  }
