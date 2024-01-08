{ lib, customLib, pkgs, ... }:
  with lib;
  customLib.mkSuite "arts" [ "users'" "leo" "suites" "arts" ] {
    parts = [ "krita" "lmms" "godot" ];

    config = cfg: {
      home-manager.users.leo.home.packages = with pkgs;
        (optional (cfg.krita) krita)
        ++ (optional (cfg.lmms) lmms)
        ++ (optional (cfg.godot) godot_4);
    };
  }
