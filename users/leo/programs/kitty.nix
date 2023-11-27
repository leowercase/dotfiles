{ config, lib, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.kitty;
  in
  {
    options.users'.leo.programs.kitty = {
      enable = mkEnableOption "my kitty";
    };

    config = mkIf cfg.enable {
      # Meow
      hm.leo.programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
      };

      users'.leo.desktop.swallow.swallowables = [ "kitty" ];
    };
  }
