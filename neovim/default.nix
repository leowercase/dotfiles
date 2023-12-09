{ system, flake, lib } @ args:
  let
    mkNvim = import ./mk_nvim.nix args;
  in
  {
    inherit mkNvim;

    packages.${system} = {
      nvim = mkNvim { inherit system; };
    };

    checks.${system}.nvim =
      flake.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        nvim = mkNvim { inherit system; gui = false; };
        name = "My NixVim configuration";
      };

    apps.${system} = {
      nvim = {
        type = "app";
        program = "${flake.self.packages.${system}.nvim}/bin/nvim";
      };
    };
  }
