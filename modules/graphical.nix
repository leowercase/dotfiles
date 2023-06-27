{ config, lib, ... }:
  with lib;
  let
    cfg = config.custom.graphical;
  in
  {
    options.custom.graphical = mkEnableOption "graphics";

    config.hardware.opengl.enable = cfg;
  }
