{ inputs', self', lib, pkgs, ... } @ args:
{
  gui ? true,
  neovideArgs ? "--no-fork",
  module ? {}
}:
  with lib;
  let
    nixvim = inputs'.nixvim.legacyPackages;
    nixvimLib = inputs'.nixvim.lib;

    nvim = nixvim.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./options.nix ./plugins.nix module ];
      };
      extraSpecialArgs = args // {
        inherit nixvim nixvimLib;
        customLib = self'.lib;
      };
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
