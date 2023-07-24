{ config, lib, flake, ... }:
  with lib;
  let
    cfg = config.custom.desktop.hyprland;
  in
  {
    options.custom.desktop.hyprland = {
      enable = mkEnableOption "Hyprland";
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional configuration in Hyprland's configuration format.";
      };
    };

    config = mkIf cfg.enable {
      custom.desktop.waylandIntegration = mkDefault true;

      # The `programs.hyprland` NixOS module needs to be enabled as well,
      # as it manages Hyprland's XDG Desktop Portal, among other things
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig =
	  let
	    inherit (config.custom) desktop;

	    init = "exec-once = ${builtins.toFile "hyprland_init.sh" desktop.init}";

	    env = (concatStringsSep "\n"
	      (map (ident: "env = ${ident}, ${desktop.env.${ident}}")
	        (attrNames config.custom.desktop.env)));
	    
	    initialVolume = toString desktop.sound.initialVolume;
	    initialMute = if desktop.sound.initialMute then "1" else "0";
	  in ''
            ${init}
	    ${env}
	    exec-once = wpctl set-volume @DEFAULT_AUDIO_SINK@ ${initialVolume}
	    exec-once = wpctl set-mute @DEFAULT_AUDIO_SINK@ ${initialMute}

	    ${cfg.extraConfig}
	  '';
      };
    };
  }
