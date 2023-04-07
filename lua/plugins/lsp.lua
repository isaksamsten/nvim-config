Format = require("helpers.format")

return {
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    ft = "rust",
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cc", function()
            require("rust-tools").hover_actions.hover_actions()
          end, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>ca", function()
            require("rust-tools").code_action_group.code_action_group()
          end, { buffer = bufnr })
        end,
      },
    },
  },

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
      {
        "ray-x/lsp_signature.nvim",
        opts = {
          bind = true,
          hint_enable = false,
          doc_lines = 3,
        },
      },
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
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          severity = { min = vim.diagnostic.severity.ERROR },
          prefix = "󱓻 ",
          format = function(diagnostic)
            local max_width = vim.g.max_width_diagnostic_virtual_text or 40
            local message = diagnostic.message
            if #diagnostic.message > max_width + 1 then
              message = string.sub(diagnostic.message, 1, max_width) .. "…"
            end
            return message
          end,
        },
        severity_sort = true,
      },

      servers = {
        pyright = {
          setup = {
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
        },
        texlab = {},
        ltex = {
          setup = {
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
        ruff_lsp = {
          on_attach = function(client, bufnr)
            client.server_capabilities.Hover = false
          end,
        },
        rust_analyzer = {
          skip_setup = true,
        },
      },
      sources = function(null_ls)
        -- NOTE: formatters are run in the order in which the are defined here.
        return {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.latexindent,
          null_ls.builtins.formatting.erlfmt, -- build and install to mason/bin
          null_ls.builtins.formatting.bibclean,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.ruff, -- we only use null-ls for formatting
          null_ls.builtins.formatting.black,
        }
      end,
    },

    config = function(_, opts)
      local lsp_zero = require("lsp-zero")
      lsp_zero.preset(opts.preset)

      local ensure_installed = {}
      local skip_server_setup = {}
      for server, config in pairs(opts.servers) do
        local name = config.name or server
        table.insert(ensure_installed, name)
        if config.skip_setup then
          table.insert(skip_server_setup, name)
        end
      end

      lsp_zero.ensure_installed(ensure_installed)
      lsp_zero.skip_server_setup(skip_server_setup)

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_mapping = lsp_zero.defaults.cmp_mappings({
        ["<CR>"] = vim.NIL,
        ["<S-Tab>"] = vim.NIL,
        ["<C-d"] = vim.NIL,
        ["<C-b"] = vim.NIL,
        ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
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
        local setup = config.setup
        if setup ~= false then
          lsp_zero.configure(server, setup or {})
        end
      end

      lsp_zero.setup_nvim_cmp({
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

      lsp_zero.on_attach(function(client, bufnr)
        -- Run custom on_attach functions on per server basis
        local config = opts.servers[client.name]
        if config then
          if config.on_attach then
            config.on_attach(client, bufnr)
          end
        end

        -- Set the tagfunc to use lsp-definition
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

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
        -- map("x", "<C-.>", vim.lsp.buf.range_code_action, "Code action")

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
      lsp_zero.setup()

      -- Setup diagnostics
      vim.diagnostic.config(opts.diagnostic)

      -- Setup null-ls. We only use null-ls for formatting
      local null_ls = require("null-ls")
      local null_opts = lsp_zero.build_options("null-ls", {})

      null_ls.setup({
        on_attach = function(client, bufnr) -- Enable format-on-save prefer null-ls for formatting
          null_opts.on_attach(client, bufnr)

          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>F", function()
              Format.format(client.id, bufnr, true, false)
            end, { remap = false, silent = true, buffer = bufnr, desc = "Format buffer" })

            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
              callback = function()
                Format.format(client.id, bufnr, false, true)
              end,
            })
          end
        end,

        sources = opts.sources(null_ls),
      })
    end,
  },
}
