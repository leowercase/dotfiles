_: {
  plugins.lsp = {
    enable = true;
    servers.rnix-lsp.enable = true;
  };

  plugins.treesitter = {
    enable = true;
    nixGrammars = true;
    ensureInstalled = "all";
    nixvimInjections = true;
    indent = true;
  };
  plugins.treesitter-context.enable = true;

  plugins.nix.enable = true;

  plugins.indent-blankline = {
    enable = true;
    useTreesitter = true;
    showCurrentContext = true;
    showCurrentContextStart = true;
  };

  plugins.lualine.enable = true;
}
