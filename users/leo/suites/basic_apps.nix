{ config, lib, customLib, pkgs, ... }:
  with lib;
  customLib.mkSuite "basic apps" [ "users'" "leo" "suites" "basicApps" ] {
    parts = [ "qutebrowser" "kitty" "btop" "tutanota" "discord" ];

    config = cfg: {
      users'.leo.programs = {
        qutebrowser.enable = cfg.qutebrowser;
        kitty.enable = cfg.kitty;
        btop.enable = cfg.btop;
      };

      home-manager.users.leo.home.packages = with pkgs;
        (optional (cfg.tutanota) tutanota-desktop)
        ++ (optional (cfg.discord) discord);
    };
  }
