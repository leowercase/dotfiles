{ lib, pkgs, ... }:
  with lib;
  custom.mkSuite "arts" [ "users'" "leo" "suites" "arts" ] {
    parts = [ "krita" "lmms" "godot" ];

    config = cfg: {
      hm.leo.home.packages = with pkgs;
        (optional (cfg.krita) krita)
        ++ (optional (cfg.lmms) lmms)
        ++ (optional (cfg.godot) godot_4);
    };
  }
