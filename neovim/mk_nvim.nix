{ flake, lib, ... } @ args: { system, features ? null }:
  with lib;
  let
    nixvim = flake.nixvim.legacyPackages.${system};
    nixvimLib = flake.nixvim.lib.${system};
    pkgs = import flake.nixpkgs { inherit system; };

    hasFeature =
      if features == null then (_: true)
      else (feat: elem feat features);

    nvim = nixvim.makeNixvimWithModule {
      inherit pkgs;
      module.imports = [ ./options.nix ./plugins.nix ];
      extraSpecialArgs = args // { inherit system nixvim nixvimLib hasFeature; };
    };

    nvimBin = "${nvim}/bin/nvim";
    neovideBin = "${pkgs.neovide}/bin/neovide";

    # Launches Neovide instead of Neovim if in a graphical environment
    nvim' = pkgs.writeShellScriptBin "nvim" ''
      [ -n "$DISPLAY" ] && command="${neovideBin} --nofork --neovim-bin ${nvimBin} --" || command="${nvimBin}"
      $command $@
    '';
  in
  if hasFeature "gui" then nvim' else nvim
