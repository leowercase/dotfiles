{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.leo.programs.neovim;
  in
  {
    options.leo.programs.neovim = {
      enable = mkEnableOption "my Neovim";
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.neovim ];
    };
  }
