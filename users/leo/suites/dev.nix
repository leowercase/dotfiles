{ config, lib, customLib, ... }:
  with lib;
  customLib.mkSuite "development" [ "users'" "leo" "suites" "dev" ] {
    parts = [ "neovim" "git" ];

    config = cfg: {
      users'.leo.programs = {
        neovim.enable = cfg.neovim;
        git.enable = cfg.git;
      };
    };
  }
