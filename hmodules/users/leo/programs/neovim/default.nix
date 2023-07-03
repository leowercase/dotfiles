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
        ++ (if cfg.pager then [ nvimpager ] else [])
	++ (if cfg.gui then [ neovide ] else []);

      xdg.configFile."nvim" = {
        source = ./.;
	recursive = true;
      };
      xdg.configFile."nvim/default.nix".enable = false;
    };
  }
