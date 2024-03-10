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
      home-manager.users.leo.programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
        settings.background_opacity = "0.5";
      };
    };
  }
