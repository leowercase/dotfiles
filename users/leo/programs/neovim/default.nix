{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.my.programs.neovim;
  in
  {
    options.my.programs.neovim = {
      enable = mkEnableOption "my Neovim";
      pager = mkEnableOption "nvimpager" // { default = cfg.enable; };
      gui = mkEnableOption "Neovide" // { default = cfg.enable; };
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ neovim ]
        ++ (optional (cfg.pager) nvimpager)
	++ (optional (cfg.gui) neovide);
    };
  }
