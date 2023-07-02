{ options, lib, myLib, pkgs, hostname, overlays, ... }:
  with lib;
  {
    imports = myLib.getModules ./.;

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # See https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "23.05";

    networking.hostName = hostname;

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ overlays ];
    };

    hardware.enableRedistributableFirmware = mkDefault true;

    # ISO 8601 time
    i18n.extraLocaleSettings.LC_TIME = mkDefault "en_DK.UTF-8";

    environment.defaultPackages = (with pkgs; [ nvi git ])
      ++ (lists.remove pkgs.nano options.environment.defaultPackages.default);
    environment.variables.EDITOR = mkOverride 999 "vi";
  }
