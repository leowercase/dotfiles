{ flake, lib, config, pkgs, ... }:
  with lib;
  let
    cfg = config.users'.leo.desktop.hyprland;
  in
  {
    options.users'.leo.desktop.hyprland = {
      enable = mkEnableOption "Hyprland";
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional configuration in Hyprland's configuration format.";
      };
    };

    config = mkIf cfg.enable {
      users'.leo.desktop.waylandIntegration = mkDefault true;

      programs.hyprland.enable = true;
      custom.audio = "pipewire";

      hm.leo.wayland.windowManager.hyprland = {
        enable = true;
        extraConfig =
	  let
	    inherit (config.users'.leo) desktop;

	    init = "exec-once = ${pkgs.writeShellScript "hyprland_init.sh" desktop.init}";

	    env = with builtins; (concatStringsSep "\n"
	      (map (ident: "env = ${ident}, ${desktop.env.${ident}}")
	        (attrNames desktop.env)));
	    
	    initialVolume = builtins.toString desktop.sound.initialVolume;
	    initialMute = if desktop.sound.initialMute then "1" else "0";
	  in ''
            # INIT
            ${init}

            # ENVIRONMENT VARIABLES
	    ${env}

            # VOLUME
	    exec-once = wpctl set-volume @DEFAULT_AUDIO_SINK@ ${initialVolume}
	    exec-once = wpctl set-mute @DEFAULT_AUDIO_SINK@ ${initialMute}

            # ADDITIONAL CONFIGURATION
            ${cfg.extraConfig}
	  '';
      };
    };
  }