{ lib, config, pkgs, ... }:
  with lib;
  let
    cfg = config.users'.leo.programs.swaylock-effects;
  in
  {
    options.users'.leo.programs.swaylock-effects = {
      enable = mkEnableOption "swaylock-effects";
      settings = mkOption {
        type = with types; attrsOf (oneOf [ bool float int string ]);
        default = {};
        description = "Any additional swaylock settings to set.";
      };
    };

    config = mkIf cfg.enable {
      hm.leo.programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings =
          let
            defaultSettings = {
              indicator = true;
              clock = true;
              show-failed-attempts = true;
              screenshots = true;
              effect-blur = "7x5";
            };
          in defaultSettings // cfg.settings;
      };
      security.pam.services.swaylock = {};
    };
  }
