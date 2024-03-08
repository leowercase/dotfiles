_: {
  plugins = {
    lsp = {
      enable = true;
      servers = {
        rnix-lsp.enable = true;
      };
    };
    treesitter = {
      enable = true;
      nixGrammars = true;
      ensureInstalled = "all";
      nixvimInjections = true;
      indent = true;
    };
    treesitter-context.enable = true;
    nix.enable = true;

    luasnip.enable = true;
    cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
        };

        sources = [
          { name = "path"; }
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          {
            name = "buffer";
            # Words from other open buffers can also be suggested
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
      };
    };

    fidget.enable = true;

    lspkind = {
      enable = true;
      cmp.enable = true;
    };

    nvim-autopairs.enable = true;

    indent-blankline = {
      enable = true;
      scope.showEnd = false;
    };

    lualine.enable = true;
  };
}
