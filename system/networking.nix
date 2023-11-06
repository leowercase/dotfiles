{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.networking;
  in
  {
    options.custom.networking = {
      enable = mkEnableOption "networking with NetworkManager";
      wifi = mkOption {
        type = with types; nullOr (enum [ "iwd" "wpa_supplicant" ]);
        default = null;
        description = "The Wi-Fi backend to use, or `null` for none.";
      };
    };

    config.networking = mkIf cfg.enable {
      networkmanager = {
        enable = true;
        wifi.backend = mkIf (cfg.wifi != null) cfg.wifi;
      };
      wireless = {
        enable = cfg.wifi == "wpa_supplicant";
        iwd.enable = cfg.wifi == "iwd";
      };
      firewall.enable = true;
    };
  }
