{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.leo.programs.btop;
  in
  {
    options.leo.programs.btop = {
      enable = mkEnableOption "my Neovim";
    };

    config = mkIf cfg.enable {
      programs.btop = {
        enable = true;
	settings.vim_keys = true;
      };
    };
  }
