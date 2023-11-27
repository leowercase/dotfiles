{ system, flake, lib } @ args:
  let
    mkNvim = import ./mk_nvim.nix args;
  in
  {
    inherit mkNvim;

    packages.${system} = {
      nvim = mkNvim { inherit system; };
      nvim-minimal = mkNvim { inherit system; features = []; };
    };

    checks.${system}.nvim =
      flake.nixvim.lib.${system}.check.mkTestDerivationFromNvim
        { inherit (flake.self.packages.${system}) nvim; };

    apps.${system} = {
      nvim = {
        type = "app";
        program = "${flake.self.packages.${system}.nvim}/bin/nvim";
      };
      nvim-minimal = {
        type = "app";
        program = "${flake.self.packages.${system}.nvim-minimal}/bin/nvim";
      };
    };
  }
