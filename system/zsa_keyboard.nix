{ config, lib, pkgs, ... }:
  with lib;
  {
    options.custom.zsaKeyboard = {
      enable = mkEnableOption "ZSA keyboard utilities";
    };

    config = mkIf config.custom.zsaKeyboard.enable {
      hardware.keyboard.zsa.enable = true;
      environment.systemPackages = [ pkgs.wally-cli ];
    };
  }
