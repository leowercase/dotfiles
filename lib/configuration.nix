lib:
  with builtins;
  with lib;
  {
    mkFlake = systems: args: flakeParts:
      let
        flakeParts' = flatten (map
          (part: map
            (system:
              let
                part' = custom.innerImport part;
                args' = args // { inherit system; };
              in
              if isFunction part' then part' args' else part')
            systems)
          flakeParts);
      in
      custom.recursiveMergeAttrsList flakeParts';

    mkConfigurations = { nixpkgs, hosts, modules, specialArgs ? {} } @ common:
      mapAttrs
        (hostname: { system, modules ? [] }:
          let
            lib = import ./. nixpkgs.lib;
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = common.modules ++ modules
              ++ [ { networking.hostName = lib.mkDefault hostname; } ];
            specialArgs = { inherit system hostname lib; } // specialArgs;
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
