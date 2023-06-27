{ lib, myLib, pkgs, hostname, ... }:
  with lib;
  {
    imports = myLib.getModules ./.;

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # See https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "23.05";

    networking.hostName = hostname;

    # ISO 8601 time
    i18n.extraLocaleSettings.LC_TIME = mkDefault "en_DK.UTF-8";

    environment.defaultPackages = mkDefault [ pkgs.nvi ];

    hardware.enableRedistributableFirmware = mkDefault true;
  }
