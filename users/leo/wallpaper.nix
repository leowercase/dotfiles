{ lib, customLib, ... }:
  with lib;
  {
    options.users'.leo.wallpaper = mkOption {
      type = types.pathInStore;
      description = "Set this to a wallpaper you like to have on your desktop.";
    };
  }
