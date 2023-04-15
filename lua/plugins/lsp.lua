Format = require("helpers.format")

local function on_attach(client, bufnr)
  -- Run custom on_attach functions on per server basis
  -- local config = opts.servers[client.name]
  -- if config then
  --   if config.on_attach then
  --     config.on_attach(client, bufnr)
  --   end
  -- end

  print("attaching")
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
end

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
    -- "VonHeikemen/lsp-zero.nvim",
    "neovim/nvim-lspconfig",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { "neovim/nvim-lspconfig", version = false },
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
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   opts = {
      --     bind = true,
      --     hint_enable = false,
      --     doc_lines = 3,
      --   },
      -- },

      {
        "isaksamsten/better-virtual-text.nvim",
        opts = {
          highlights = {
            BetterVirtualTextError = { link = "NonText" },
            BetterVirtualTextWarn = { link = "NonText" },
            BetterVirtualTextInfo = { link = "NonText" },
            BetterVirtualTextHint = { link = "NonText" },
            BetterVirtualTextPrefixError = { link = "DiagnosticSignError" },
            BetterVirtualTextPrefixWarn = { link = "DiagnosticSignWarn" },
            BetterVirtualTextPrefixInfo = { link = "DiagnosticSignInfo" },
            BetterVirtualTextPrefixHint = { link = "DiagnosticSignHint" },
          },
        },
      },
    },

    opts = {

      diagnostic = {
        signs = false,
        underline = true,
        update_in_insert = false,
        virtual_text = false,

        better_virtual_text = {
          spacing = 4,
          -- severity = { min = vim.diagnostic.severity.ERROR },
          prefix = function(diagnostic)
            local icons = require("config.icons").diagnostics
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              return icons.error
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
              return icons.warn
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
              return icons.info
            else
              return icons.hint
            end
          end,
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
        lua_ls = {},
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
        ruff_lsp = {
          on_attach = function(client, bufnr)
            client.server_capabilities.Hover = false
          end,
        },
        rust_analyzer = { skip_setup = true },
      },
      sources = function(null_ls)
        -- NOTE: formatters are run in the order in which the are defined here.
        return {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.latexindent,
          null_ls.builtins.formatting.erlfmt, -- build and install to mason/bin
          null_ls.builtins.formatting.bibclean, -- installed by system
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.ruff, -- we only use null-ls for formatting
          null_ls.builtins.formatting.black,
        }
      end,
    },

    config = function(_, opts)
      -- Setup diagnostics
      -- local sign_icons = require("config.icons").diagnostics
      -- vim.fn.sign_define("DiagnosticSignError", { text = sign_icons.error, texthl = "DiagnosticSignError", numhl = "" })
      -- vim.fn.sign_define("DiagnosticSignWarn", { text = sign_icons.warn, texthl = "DiagnosticSignWarn", numhl = "" })
      -- vim.fn.sign_define("DiagnosticSignInfo", { text = sign_icons.info, texthl = "DiagnosticSignInfo", numhl = "" })
      -- vim.fn.sign_define("DiagnosticSignHint", { text = sign_icons.hint, texthl = "DiagnosticSignHint", numhl = "" })
      vim.diagnostic.config(opts.diagnostic)
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local ensure_installed = {}
      local setup_servers = {}
      for server, config in pairs(opts.servers) do
        table.insert(ensure_installed, server)
        if config.skip_setup ~= false then
          table.insert(setup_servers, server)
        end
      end
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
      })

      for _, server in pairs(setup_servers) do
        local config = opts.servers[server]
        local local_on_attach = on_attach
        if config.on_attach then
          local_on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            config.on_attach(client, bufnr)
          end
        end

        lspconfig[server].setup({
          on_attach = local_on_attach,
          capabilities = capabilities,
          settings = config.settings or {},
        })
      end

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        experimental = {
          ghost_text = {
            hl_group = "NonText",
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(_, item)
            local icons = require("config.icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        mapping = {
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
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
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Setup null-ls. We only use null-ls for formatting
      local null_ls = require("null-ls")
      null_ls.setup({
        on_attach = function(client, bufnr) -- Enable format-on-save prefer null-ls for formatting
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
