{ config, lib, ... }:
  with lib;
  let
    cfg = config.my.programs.git;
  in
  {
    options.my.programs.git = {
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
