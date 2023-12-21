{ config, lib, pkgs, ... }:
  with lib;
  {
    options.system'.zsaKeyboard = {
      enable = mkEnableOption "ZSA keyboard utilities";
    };

    config = mkIf config.system'.zsaKeyboard.enable {
      hardware.keyboard.zsa.enable = true;
      environment.systemPackages = [ pkgs.wally-cli ];
    };
  }
