{ config, lib, ... }:
  with lib;
  let
    cfg = config.my.programs.kitty;
  in
  {
    options.my.programs.kitty = {
      enable = mkEnableOption "my kitty";
    };

    config = mkIf cfg.enable {
      # Meow
      programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
      };
    };
  }
