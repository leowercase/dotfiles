{ lib, customLib, pkgs, ... }:
  with lib;
  customLib.mkSuite "gaming" [ "users'" "leo" "suites" "gaming" ] {
    parts = [ "steam" "minecraft" ];

    config = cfg: {
      programs.steam = mkIf cfg.steam {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      hm.leo.home.packages =
        optional (cfg.minecraft) pkgs.prismlauncher;
    };
  }
