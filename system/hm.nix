{ inputs, lib, config, options, ... }:
  with lib;
  {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    # Shorter to write, is all
    options.hm = mkOption {
      default = {};
      type = with types; attrsOf (custom.types.listOfOrSingleton raw);
    };

    config.home-manager.users = mapAttrs
      (_: modules: { imports = modules; })
      config.hm;
  }
