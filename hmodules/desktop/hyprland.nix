{ config, lib, flake, ... }:
  with lib;
  let
    cfg = config.custom.desktop.hyprland;
  in
  {
    imports = [ flake.hyprland.homeManagerModules.default ];

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
	    init = "exec-once = ${builtins.toFile "hyprland_init.sh" config.custom.desktop.init}";

	    env = (strings.concatStringsSep "\n"
	      (map (ident: "env = ${ident}, ${config.custom.desktop.env.${ident}}")
	        (builtins.attrNames config.custom.desktop.env)));
	  in ''
            ${init}
	    ${env}

	    ${cfg.extraConfig}
	  '';
      };
    };
  }
