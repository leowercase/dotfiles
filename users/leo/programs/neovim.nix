{ self', lib, pkgs, config, ... } @ args:
  with lib;
  let
    cfg = config.users'.leo.programs.neovim;
  in
  {
    options.users'.leo.programs.neovim = {
      enable = mkEnableOption "Neovim";
      pager = mkEnableOption "nvimpager" // { default = cfg.enable; };
    };

    config.home-manager.users.leo.home.packages =
      (optional cfg.enable self'.packages.nvim)
      ++ (optional cfg.pager pkgs.nvimpager);
  }
