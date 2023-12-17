_:
  {
    perSystem = { inputs', self', pkgs, ... } @ args:
      let
        mkNvim = import ./mk_nvim.nix args;
      in
      {
        lib = { inherit mkNvim; };

        packages.nvim = mkNvim {};

        apps.nvim = {
          type = "app";
          program = "${self'.packages.nvim}/bin/nvim";
        };

        checks.nvim =
          inputs'.nixvim.lib.check.mkTestDerivationFromNvim {
            nvim = mkNvim { gui = false; };
            name = "My NixVim configuration";
          };
      };
  }
