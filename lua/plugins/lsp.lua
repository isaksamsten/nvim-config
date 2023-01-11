return {
  {
    event = "BufReadPre",
    "jose-elias-alvarez/null-ls.nvim",
    config = function(_, opts)
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.completion.spell,
        },
      })
    end,
  },

  { "folke/neoconf.nvim", config = true },

  {
    "VonHeikemen/lsp-zero.nvim",
    event = "BufReadPre",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function(_, opts)
      local lsp = require("lsp-zero")
      lsp.preset("recommended")
      lsp.set_preferences({
        sign_icons = require("config.icons").diagnostics,
      })
      lsp.ensure_installed({
        "pyright",
      })
      lsp.setup_nvim_cmp({
        formatting = {
          format = function(_, item)
            local icons = require("config.icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
      })
      lsp.setup()
    end,
  },
}
