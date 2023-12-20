{ inputs, lib, customLib, ... } @ args:
  with lib;
  let
    # The lib being an option allows other modules to extend it
    option = mkOption {
      type = with types; lazyAttrsOf anything;
      description = "This custom library contains helper functions.";
    };
  in
  {
    # Per-system lib
    imports = singleton
      (inputs.flake-parts.lib
        .mkTransposedPerSystemModule {
          name = "lib";
          inherit option;
          file = ./default.nix;
        });

    # "Systemless" lib
    options.lib' = option;

    config = {
      # The base lib, which is given as an argument to the flake modules
      _module.args.customLib = 
        let
          subLibs = [ ./attrs.nix ./types.nix ./filesystem.nix ./configuration.nix ];

          importLib = file: import file args;
        in
        attrsets.mergeAttrsList (map importLib subLibs);

      perSystem = _: { lib = customLib; };

      flake.lib' = customLib;
    };
  }
