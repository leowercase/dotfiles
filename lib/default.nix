{ inputs, lib, ... } @ args:
  with lib;
  let
    option = mkOption {
      type = with types; attrsOf anything;
      description = "This custom library contains helper functions.";
    };

    pkgsOption = mkOption {
      type = with types; uniq (attrsOf anything);
      description = "A custom library (`custom`) wrapped inside the Nixpkgs lib.";
    };

    wrapWithNixpkgsLib = custom: lib.extend (_: _: { inherit custom; });
  in
  {
    options = {
      lib = option;
      nixpkgsLib = pkgsOption;
    };

    imports =
      let
        inherit (inputs.flake-parts.lib) mkTransposedPerSystemModule;

        libModule = mkTransposedPerSystemModule {
          name = "lib";
          inherit option;
          file = ./default.nix;
        };
        
        nixpkgsLibModule = mkTransposedPerSystemModule {
          name = "nixpkgsLib";
          option = pkgsOption;
          file = ./default.nix;
        };
      in
      [ libModule nixpkgsLibModule ];

    config = {
      flake = rec {
        lib' =
          let
            subLibs = [ ./attrs.nix ./types.nix ./filesystem.nix ./configuration.nix ];

            importLib = file: import file nixpkgsLib' args;
          in
          attrsets.mergeAttrsList (map importLib subLibs);

        nixpkgsLib' = wrapWithNixpkgsLib lib';
      };

      _module.args = { inherit (inputs.self.nixpkgsLib') custom; };

      perSystem = { config, ... }: rec {
        lib = inputs.self.lib';

        nixpkgsLib = wrapWithNixpkgsLib lib;

        _module.args = { inherit (config.nixpkgsLib) custom; };
      };
    };
  }
