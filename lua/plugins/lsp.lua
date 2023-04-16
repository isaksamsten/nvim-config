Format = require("helpers.format")
local function br2lf(s)
  return s:gsub("<br>", "\n")
end

local function on_attach(client, bufnr)
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
    "neovim/nvim-lspconfig",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        "ray-x/lsp_signature.nvim",
        opts = {
          bind = true,
          hint_enable = false,
          doc_lines = 3,
          handler_opts = {
            border = "solid",
          },
        },
      },

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
      hover = {
        border = "solid",
      },
      diagnostic = {
        signs = false,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        float = {
          border = "solid",
          header = {},
          suffix = function(diag)
            return (" %s (%s)"):format(diag.source, diag.code), "DiagnosticFloatSuffix"
          end,
          prefix = {},
          format = function(diag)
            local icon = require("config.icons").diagnostics.by_severity(diag.severity)
            return ("%s %s"):format(icon, diag.message)
          end,
        },
        better_virtual_text = {
          spacing = 4,
          -- severity = { min = vim.diagnostic.severity.ERROR },
          prefix = function(diagnostic)
            return require("config.icons").diagnostics.by_severity(diagnostic.severity)
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
      local sign_icons = require("config.icons").diagnostics
      vim.fn.sign_define("DiagnosticSignError", { text = sign_icons.error, texthl = "DiagnosticSignError", numhl = "" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = sign_icons.warn, texthl = "DiagnosticSignWarn", numhl = "" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = sign_icons.info, texthl = "DiagnosticSignInfo", numhl = "" })
      vim.fn.sign_define("DiagnosticSignHint", { text = sign_icons.hint, texthl = "DiagnosticSignHint", numhl = "" })
      vim.diagnostic.config(opts.diagnostic)
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

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

      local hover = vim.lsp.with(vim.lsp.handlers.hover, opts.hover)
      vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
        if result then
          if type(result.contents) == "string" then
            ---@cast result {contents: string}
            result.contents = br2lf(result.contents)
          elseif result.contents.value then
            if result.contents.language or result.contents.kind == "markdown" then
              result.contents.value = br2lf(result.contents.value)
            end
          elseif vim.tbl_islist(result.contents) then
            ---@cast result {contents: MarkedString[]}
            for i, v in ipairs(result.contents) do
              if type(v) == "string" then
                result.contents[i] = br2lf(v)
              else
                v.value = br2lf(v.value)
              end
            end
          end
        end
        config = config or {}
        config.max_width = 80
        hover(err, result, ctx, config)
      end

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
