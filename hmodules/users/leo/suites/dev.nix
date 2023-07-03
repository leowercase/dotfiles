{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.suites.dev;
  in
  {
    options.my.suites.dev = {
      enable = mkEnableOption "the development suite";
    };

    config = mkIf cfg.enable {
      my = {
        programs = {
          neovim.enable = true;
	  git.enable = true;
	  btop.enable = true;
	};
      };

      home.sessionVariables = {
        EDITOR = "nvim";
	VISUAL = "nvim";
      };
    };
  }
