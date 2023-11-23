lib: flake: system:
  let
    nixvim = flake.nixvim.legacyPackages.${system};
    nixvimLib = flake.nixvim.lib.${system};
    pkgs = import flake.nixpkgs { inherit system; };
  in
  nixvim.makeNixvimWithModule {
    inherit pkgs;
    module.imports = [ ./options.nix ./plugins.nix ];
    extraSpecialArgs = { inherit flake lib system nixvim nixvimLib; };
  }
