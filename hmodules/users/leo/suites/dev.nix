{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.leo.suites.dev;
  in
  {
    options.leo.suites.dev = {
      enable = mkEnableOption "the development suite";
    };

    config = mkIf cfg.enable {
      leo = {
        programs = {
          neovim.enable = true;
	  git.enable = true;
	};
      };

      home.sessionVariables = {
        EDITOR = "nvim";
	VISUAL = "nvim";
      };
    };
  }
