{ config, lib, myLib, pkgs, flake, ... } @ args:
  with lib;
  let
    cfg = config.my.programs.neovim;
  in
  {
    imports = [ flake.nixvim.homeManagerModules.nixvim ];

    options.my.programs.neovim = {
      enable = mkEnableOption "my Neovim";
      pager = mkEnableOption "nvimpager" // { default = cfg.enable; };
      gui = mkEnableOption "Neovide" // { default = cfg.enable; };
    };

    config = mkIf cfg.enable {
      programs.nixvim =
        let
          vimModules = map
            (f: import f args)
            (remove ./default.nix
              (filesystem.listFilesRecursive ./.));
        in
        mkMerge ([ { enable = true; } ] ++ vimModules);

      home.packages = with pkgs;
        (optional (cfg.pager) nvimpager)
	++ (optional (cfg.gui) neovide);
    };
  }
