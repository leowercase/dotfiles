{ config, lib, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.btop;
  in
  {
    options.users'.leo.programs.btop = {
      enable = mkEnableOption "my btop";
    };

    config.hm.leo = mkIf cfg.enable {
      programs.btop = {
        enable = true;
	settings.vim_keys = true;
      };
    };
  }
