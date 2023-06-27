{ config, lib, ... }:
  with lib;
  let
    cfg = config.leo.programs.git;
  in
  {
    options.leo.programs.git = {
      enable = mkEnableOption "my Git";
    };

    config = mkIf cfg.enable {
      programs.git = {
        enable = true;
        userName = "leowercase";
        userEmail = "126769796+leowercase@users.noreply.github.com";
      };
    };
  }
