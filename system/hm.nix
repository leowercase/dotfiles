{ inputs, lib, customLib, config, options, ... }:
  with lib;
  {
    # Shorter to write, is all
    options.hm = mkOption {
      default = {};
      type = with types; attrsOf (customLib.types.listOfOrSingleton raw);
    };

    config.home-manager.users = mapAttrs
      (_: modules: { imports = modules; })
      config.hm;
  }
