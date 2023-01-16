return {

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
      "jose-elias-alvarez/null-ls.nvim",
    },

    config = function(_, opts)
      local lsp = require("lsp-zero")
      lsp.preset("recommended")
      lsp.set_preferences({ set_lsp_keymaps = false, sign_icons = require("config.icons").diagnostics })
      lsp.ensure_installed({
        "pyright",
        "ltex",
        "texlab",
        "erlangls",
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

      lsp.on_attach(function(client, bufnr)
        local map = function(m, lhs, rhs, desc)
          local opts = { remap = false, silent = true, buffer = bufnr, desc = desc }
          vim.keymap.set(m, lhs, rhs, opts)
        end

        map("n", "K", vim.lsp.buf.hover, "Show information")
        map("n", "<C-i>", function()
          vim.diagnostic.open_float(nil, { scope = "line" })
        end, "Show diagnostics")
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "gr", vim.lsp.buf.references, "Show references")
        map("n", "<C-,>", vim.lsp.buf.signature_help, "Show signature help")

        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<C-CR>", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<C-.>", vim.lsp.buf.code_action, "Code action")
        map("x", "<C-.>", vim.lsp.buf.range_code_action, "Code action")
      end)
      lsp.setup()

      local null_ls = require("null-ls")
      local null_opts = lsp.build_options("null-ls", {})

      null_ls.setup({
        on_attach = function(client, bufnr) -- Enable format-on-save prefer null-ls for formatting
          null_opts.on_attach(client, bufnr)

          local function format_fn(async)
            vim.lsp.buf.format({
              id = client.id,
              bufnr = bufnr,
              async = async,
              timeout_ms = 5000,
            })
          end

          vim.keymap.set("n", "<leader>F", function()
            format_fn(true)
          end, { remap = false, silent = true, buffer = bufnr, desc = "Format buffer" })

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
            callback = function()
              format_fn(false)
            end,
          })
        end,
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.latexindent,
          null_ls.builtins.formatting.erlfmt, -- build and install to mason/bin
        },
      })
    end,
  },
}
