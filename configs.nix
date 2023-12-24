# This module makes defining NixOS configurations a bit nicer
{ inputs, lib, customLib, withSystem, config, ... }:
  with lib;
  let
    cfg = config.systemConfigs;

    commonOptions = {
      options = {
        modules = mkOption {
          type = customLib.types.listOfOrSingleton types.deferredModule;
          default = [];
          description =
            "The root module from which all custom modules are imported.";
        };
        specialArgs = mkOption {
          type = with types; attrsOf raw;
          default = {};
          description = "Any arguments you want to pass on to the modules.";
        };
      };
    };

    commonModule = types.submodule commonOptions;

    hostModule = types.submodule {
      imports = singleton commonOptions;
      options.system = mkOption {
        type = types.str;
        description = "The host's system, for example `x86_64-linux`.";
      };
    };
  in
  {
    options.systemConfigs = {
      hosts = mkOption {
        type = types.attrsOf hostModule;
        default = {};
        description = "Machines you want to configure.";
      };
      common = mkOption {
        type = types.functionTo commonModule;
        description = "Common configuration shared with all machines.";
      };
    };

    config.flake.nixosConfigurations = mkIf (cfg.hosts != {})
      (mapAttrs
        (hostname: { system, ... } @ host:
          withSystem system (perSystemArgs:
            let
              common = cfg.common perSystemArgs;

              modules =
                [ { networking.hostName = mkDefault hostname; } ]
                ++ common.modules ++ host.modules;

              specialArgs =
                { inherit hostname system; }
                // common.specialArgs // host.specialArgs;
            in
            inputs.nixpkgs.lib.nixosSystem
              { inherit system modules specialArgs; }))
        cfg.hosts);
  }
