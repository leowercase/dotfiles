args:
  let
    mkNvim = import ./mk_nvim.nix args;
  in
  {
    flake = { inherit mkNvim; };

    perSystem = { system, inputs', self', ... }: {
      packages.nvim = mkNvim { inherit system; };

      apps.nvim = {
        type = "app";
        program = "${self'.packages.nvim}/bin/nvim";
      };

      checks.nvim =
        inputs'.nixvim.lib.check.mkTestDerivationFromNvim {
          nvim = mkNvim { inherit system; gui = false; };
          name = "My NixVim configuration";
        };
    };
  }
