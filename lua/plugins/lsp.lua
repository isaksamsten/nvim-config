vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    require("config.keymaps").lsp_on_attach(client, bufnr)

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
  end,
})

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    opts = {
      root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
    },
    config = function(_, opts)
      local resolve_opts = function()
        local root_dir = require("jdtls.setup").find_root(opts.root_markers or { ".git", "pom.xml", "build.gradle" })
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
        if vim.loop.fs_stat(workspace_dir) == nil then
          os.execute("mkdir " .. workspace_dir)
        end
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        local os
        if vim.fn.has("macunix") then
          os = "mac"
        else
          os = "linux"
        end

        return {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. install_path .. "/lombok.jar",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            install_path .. "/config_" .. os,
            "-data",
            workspace_dir,
          },
          root_dir = root_dir,
        }
      end
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "java", -- autocmd to start jdtls
        callback = function()
          local start_opts = resolve_opts()
          if start_opts.root_dir and start_opts.root_dir ~= "" then
            require("jdtls").start_or_attach(start_opts)
          end
        end,
      })
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
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
      "hrsh7th/cmp-nvim-lsp",
      "barreiroleo/ltex_extra.nvim",
      {
        "ray-x/lsp_signature.nvim",
        version = false,
        opts = function()
          local icons = require("config.icons")
          return {
            bind = true,
            hint_enable = false,
            floating_window = true,
            doc_lines = 2,
            transparency = 20,
            handler_opts = {
              border = icons.borders.outer.all,
            },
          }
        end,
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
        border = require("config.icons").borders.outer.all,
        max_width = 80,
        max_height = 25,
      },
      diagnostic = {
        signs = false,
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        float = {
          border = require("config.icons").borders.outer.all,
          severity_sort = true,
          header = {},
          suffix = function(diag)
            local message
            if diag.code then
              message = ("%s (%s)"):format(diag.source, diag.code)
            else
              message = diag.source
            end
            return " " .. message, "DiagnosticFloatingSuffix"
          end,
          prefix = function(diag)
            local severity = vim.diagnostic.severity[diag.severity]
            severity = string.sub(severity, 0, 1) .. string.sub(severity, 2, -1):lower()
            return require("config.icons"):get_diagnostic(diag.severity), "DiagnosticSign" .. severity
          end,
          format = function(diag)
            return diag.message
          end,
        },
        better_virtual_text = {
          spacing = 4,
          prefix = function(diagnostic)
            if diagnostic.source == "LTeX" then
              return ""
            end
            return require("config.icons"):get_diagnostic(diagnostic.severity)
          end,
          format = function(diagnostic)
            if diagnostic.source == "LTeX" then
              return ""
            end
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
        bashls = {},
        clangd = {},
        erlangls = { skip_install = true },
        esbonio = {},
        jdtls = { skip_setup = true },
        -- pylance = { skip_install = true },
        jedi_language_server = {
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = false,
                },
              },
            },
          },
        },
        lua_ls = {},
        jsonls = {},
        marksman = {},
        ltex = {
          on_attach = function(client, bufnr)
            require("ltex_extra").setup({ path = "~/.ltex/" })
          end,
          filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "mail" },
          settings = {
            ["ltex-ls"] = {
              logLevel = "severe",
            },
            additionalRules = {
              motherTongue = "sv",
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, bufnr)
            client.server_capabilities.hoverProvider = false
          end,
        },
        rust_analyzer = { skip_setup = true },
        yamlls = {},
      },
    },

    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostic)

      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local ensure_installed = {}
      local setup_servers = {}
      for server, config in pairs(opts.servers) do
        if config.skip_install ~= true then
          table.insert(ensure_installed, server)
        end
        if config.skip_setup ~= true then
          table.insert(setup_servers, server)
        end
      end
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
      })
      for _, server in pairs(setup_servers) do
        local config = opts.servers[server]
        lspconfig[server].setup({
          on_attach = config.on_attach,
          filetypes = config.filetypes,
          capabilities = vim.tbl_extend("force", capabilities, config.capabilities or {}),
          settings = config.settings or {},
        })
      end

      local hover = vim.lsp.with(vim.lsp.handlers.hover, opts.hover)
      vim.lsp.handlers["textDocument/hover"] = hover

      local manager = require("lspconfig.manager")
      local _start_new_client = manager._start_new_client
      function manager:_start_new_client(_, new_config, ...)
        local bin = new_config and new_config.cmd and new_config.cmd[1]
        if bin and vim.fn.executable(bin) == 0 then
          return
        end
        return _start_new_client(self, _, new_config, ...)
      end
    end,
  },
}
