_: {
  programs.nixvim.plugins = {
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
    nvim-cmp = {
      enable = true;
      snippet.expand = "luasnip";
      mapping = {
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<Tab>" = {
          modes = [ "i" "s" ];
          action = "cmp.mapping.select_next_item()";
        };
        "<S-Tab>" = {
          modes = [ "i" "s" ];
          action = "cmp.mapping.select_prev_item()";
        };
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
