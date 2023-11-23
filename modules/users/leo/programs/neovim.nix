{ flake, system, lib, pkgs, config, ... } @ args:
  with lib;
  let
    cfg = config.users'.leo.programs.neovim;
  in
  {
    options.users'.leo.programs.neovim = {
      enable = mkEnableOption "Neovim";
      pager = mkEnableOption "nvimpager" // { default = cfg.enable; };
      gui = mkEnableOption "Neovide" // { default = cfg.enable; };
    };

    config.hm.leo = mkIf cfg.enable {
      home.packages =
        [ flake.self.packages.${system}.nvim ]
        ++ (optional (cfg.pager) pkgs.nvimpager)
        ++ (optional (cfg.gui) pkgs.neovide);
    };
  }
