{ inputs, options, lib, customLib, pkgs, hostname, ... }:
  with lib;
  let
    # See https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  in
  {
    imports = customLib.getModules'' ./.;

    system = { inherit stateVersion; };
    home-manager.sharedModules = singleton {
      home = { inherit stateVersion; };
    };

    hardware.enableRedistributableFirmware = mkDefault true;

    # ISO 8601 time by default
    i18n.extraLocaleSettings.LC_TIME = mkDefault "en_DK.UTF-8";

    # nvi is the default lightweight editor instead of nano.
    # Also Git is included by default, because flakes
    environment.defaultPackages = (with pkgs; [ nvi git ])
      ++ (remove pkgs.nano options.environment.defaultPackages.default);
    environment.variables.EDITOR = mkOverride 999 "vi";
  }
