{ flake, lib, pkgs, config, ... } @ args:
  with lib;
  let
    cfg = config.users'.leo.programs.neovim;
  in
  {
    options.users'.leo.programs.neovim = {
      enable = mkEnableOption "my Neovim";
      pager = mkEnableOption "nvimpager" // { default = cfg.enable; };
      gui = mkEnableOption "Neovide" // { default = cfg.enable; };
    };

    config.hm.leo = mkIf cfg.enable {
      imports = [ flake.nixvim.homeManagerModules.nixvim ];

      programs.nixvim =
        let
          vimModules = map
            (f: import f args)
            (remove ./default.nix
              (filesystem.listFilesRecursive ./.));
        in
        mkMerge ([ { enable = true; } ] ++ vimModules);

      home.packages =
        (optional (cfg.pager) pkgs.nvimpager)
	++ (optional (cfg.gui) pkgs.neovide);
    };
  }
