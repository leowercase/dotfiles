{ inputs, lib, customLib, ... }:
  with builtins;
  with lib;
  {
    mkConfigurations = { hosts, modules, specialArgs ? {} } @ common:
      mapAttrs
        (hostname: { system, modules ? [] }:
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = common.modules ++ modules
              ++ [ { networking.hostName = mkDefault hostname; } ];
            specialArgs = { inherit system inputs hostname lib customLib; } // specialArgs;
          })
        hosts;

    mkSuite = name: modulePath: { parts, config }: {
      imports = singleton (args:
        with args.lib;
        {
          options = setAttrByPath modulePath {
            enable = mkEnableOption "the ${name} suite";
            exclude = mkOption {
              type = with types; listOf str;
              default = [];
              description =
                let
                  parts' = (concatStringsSep ", "
                    (sublist 0 ((length parts) - 1) parts));
                in
                "Exclude any of ${parts'} or ${last parts}.";
            };
          };

          config =
            let
              cfg = getAttrFromPath modulePath args.config;

              included = (listToAttrs
                (map
                  (part: nameValuePair part (!(elem part cfg.exclude)))
                  parts));
            in
            mkIf cfg.enable (config included);
        });
    };
  }
