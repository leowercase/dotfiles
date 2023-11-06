{ config, lib, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.kitty;
  in
  {
    options.users'.leo.programs.kitty = {
      enable = mkEnableOption "my kitty";
    };

    config.hm.leo = mkIf cfg.enable {
      # Meow
      programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
      };
    };
  }
