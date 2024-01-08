{ config, lib, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.git;
  in
  {
    options.users'.leo.programs.git = {
      enable = mkEnableOption "my Git";
    };

    config.home-manager.users.leo = mkIf cfg.enable {
      programs.git = {
        enable = true;
        userName = "leowercase";
        userEmail = "126769796+leowercase@users.noreply.github.com";
      };
    };
  }
