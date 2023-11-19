{ lib, config, ... }:
  {
    config.hm.leo = lib.mkIf config.users'.leo.enable {
      # My shell
      programs.bash = {
        enable = true;
        enableCompletion = true;
      };

      # Editor alias, because I'm lazy
      home.shellAliases.e = config.users'.leo.programs.default.editor;
    };
  }
