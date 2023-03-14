return {
  {
    "VonHeikemen/lsp-zero.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "neovim/nvim-lspconfig", version = false },
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
      "ray-x/lsp_signature.nvim",
    },

    opts = {
      preset = {
        name = "minimal",
        set_lsp_keymaps = false,
        manage_nvim_cmp = true,
        suggest_lsp_servers = true,
        sign_icons = require("config.icons").diagnostics,
      },

      diagnostic = {
        underline = true,
        update_in_insert = true,
        virtual_text = false, --[[ { spacing = 4, prefix = "●" }, ]]
        severity_sort = true,
      },

      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "off",
              },
            },
          },
        },
        texlab = {},
        ltex = {
          settings = {
            additionalRules = {
              motherTongeu = "sv",
            },

            dictionary = {
              ["en-US"] = { ":en-US-personal-dictionary" },
            },
          },
        },
      },
      sources = function(null_ls)
        return {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.latexindent,
          null_ls.builtins.formatting.erlfmt, -- build and install to mason/bin
          null_ls.builtins.formatting.bibclean,
          null_ls.builtins.formatting.prettier,
        }
      end,
    },

    config = function(_, opts)
      local lsp = require("lsp-zero")
      lsp.preset(opts.preset)

      local ensure_installed = {}
      for server, _ in pairs(opts.servers) do
        table.insert(ensure_installed, server)
      end

      lsp.ensure_installed(ensure_installed)

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_mapping = lsp.defaults.cmp_mappings({
        ["<Esc>"] = cmp.mapping.abort(),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-f>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- go to previous placeholder in the snippet
        ["<C-b>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      for server, config in pairs(opts.servers) do
        lsp.configure(server, config)
      end

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
        mapping = cmp_mapping,
      })

      lsp.on_attach(function(client, bufnr)
        require("lsp_signature").on_attach({
          bind = true,
          hint_enable = false,
          doc_lines = 3,
        }, bufnr)

        local map = function(m, lhs, rhs, desc)
          vim.keymap.set(m, lhs, rhs, { remap = false, silent = true, buffer = bufnr, desc = desc })
        end

        map("n", "K", vim.lsp.buf.hover, "Show information")
        map("n", "<C-,>", function()
          vim.diagnostic.open_float(nil, { scope = "line" })
        end, "Show diagnostics")
        map("n", "[,", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "],", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "gr", vim.lsp.buf.references, "Show references")

        map("n", "<C-CR>", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<C-.>", vim.lsp.buf.code_action, "Code action")
        map("x", "<C-.>", vim.lsp.buf.range_code_action, "Code action")

        -- Setup LSP Highlight if availiable
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
          vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
          })
        end
      end)
      lsp.setup()

      -- Setup diagnostics
      vim.diagnostic.config(opts.diagnostic)

      -- Setup null-ls. We only use null-ls for formatting
      local null_ls = require("null-ls")
      local null_opts = lsp.build_options("null-ls", {})

      null_ls.setup({
        on_attach = function(client, bufnr) -- Enable format-on-save prefer null-ls for formatting
          null_opts.on_attach(client, bufnr)

          if client.supports_method("textDocument/formatting") then
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
          end
        end,

        sources = opts.sources(null_ls),
      })
    end,
  },
}
