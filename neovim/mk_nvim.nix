{ flake, lib, ... } @ args:
{
  system,
  gui ? true,
  neovideArgs ? "--nofork",
  module ? {}
}:
  with lib;
  let
    nixvim = flake.nixvim.legacyPackages.${system};
    nixvimLib = flake.nixvim.lib.${system};
    pkgs = import flake.nixpkgs { inherit system; };

    nvim = nixvim.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./options.nix ./plugins.nix module ];
      };
      extraSpecialArgs = args // { inherit system nixvim nixvimLib; };
    };

    nvimBin = "${nvim}/bin/nvim";
    neovideBin = "${pkgs.neovide}/bin/neovide";

    neovideArgs' = if isString neovideArgs
      then neovideArgs
      else cli.toGNUCommandLineShell neovideArgs;

    # Launches Neovide instead of Neovim if in a graphical environment
    nvim' = pkgs.writeShellScriptBin "nvim" ''
      [ "$DISPLAY" ] && command="${neovideBin} ${neovideArgs'} --neovim-bin ${nvimBin} --" || command="${nvimBin}"
      $command $@
    '';
  in
  if gui then nvim' else nvim
