{ config, lib, flake, ... }:
  with lib;
  let
    cfg = config.custom.wm.hyprland;
  in
  {
    imports = [ flake.hyprland.homeManagerModules.default ];

    options.custom.wm.hyprland = {
      enable = mkEnableOption "Hyprland";
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional configuration in Hyprland's configuration format.";
      };
    };

    config = mkIf cfg.enable {
      custom.wayland.enable = true;

      wayland.windowManager.hyprland = {
        enable = true;
        inherit (cfg) extraConfig;
      };
    };
  }
