_: {
  perSystem = { inputs', self', pkgs, ... } @ args:
    let
      nixvim = inputs'.nixvim.legacyPackages;
      nixvimLib = inputs'.nixvim.lib;

      mkNvim = { module ? {}, specialArgs ? {} }:
        nixvim.makeNixvimWithModule {
          inherit pkgs;
          module.imports = [ ./options.nix ./plugins.nix module ];
          extraSpecialArgs =
            args
            // { inherit nixvim nixvimLib; customLib = self'.lib; }
            // specialArgs;
        };
    in
    {
      lib = { inherit mkNvim; };

      packages.nvim = mkNvim {};

      apps.nvim = {
        type = "app";
        program = "${self'.packages.nvim}/bin/nvim";
      };

      checks.nvim = nixvimLib.check.mkTestDerivationFromNvim {
        inherit (self'.packages) nvim;
        name = "My NixVim configuration";
      };
    };
}
