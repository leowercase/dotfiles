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
      # The `programs.hyprland` NixOS module needs to be enabled as well,
      # as it manages Hyprland's XDG Desktop Portal, among other things
      wayland.windowManager.hyprland = {
        enable = true;
        inherit (cfg) extraConfig;
      };
    };
  }
