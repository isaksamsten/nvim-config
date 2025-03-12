vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    require("config.keymaps").lsp_on_attach(client, bufnr)

    if client:supports_method("textDocument/documentHighlight") then
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
    -- if client.supports_method("textDocument/inlayHint") then
    --   if vim.b.inlay_hint_disable == nil then
    --     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    --   end
    --
    --   vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = true })
    --   vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_inlay_hints" })
    --
    --   vim.api.nvim_create_autocmd("InsertEnter", {
    --     callback = function(inner_args)
    --       if require("helpers.toggle").is_inlay_hint_active and vim.b.inlay_hint_disable ~= true then
    --         vim.lsp.inlay_hint.enable(false, { bufnr = inner_args.buf })
    --       end
    --     end,
    --     group = "lsp_inlay_hints",
    --     buffer = bufnr,
    --   })
    --   vim.api.nvim_create_autocmd("InsertLeave", {
    --     callback = function(inner_args)
    --       if require("helpers.toggle").is_inlay_hint_active and vim.b.inlay_hint_disable ~= true then
    --         vim.lsp.inlay_hint.enable(true, { bufnr = inner_args.buf })
    --       end
    --     end,
    --     group = "lsp_inlay_hints",
    --     buffer = bufnr,
    --   })
    -- end

    if client:supports_method("textDocument/codeLens") and vim.lsp.codelens and not vim.g.disable_codelens then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
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
    keys = {
      {
        "crv",
        function()
          require("jdtls").extract_variable()
        end,
        desc = "Extract variable",
      },
      {
        "crv",
        function()
          require("jdtls").extract_variable(true)
        end,
        mode = "v",
        desc = "Extract variable",
      },
      {
        "crc",
        function()
          require("jdtls").extract_constant()
        end,
        desc = "Extract constant",
      },
      {
        "crc",
        function()
          require("jdtls").extract_constant(true)
        end,
        mode = "v",
        desc = "Extract constant",
      },
      {
        "crm",
        function()
          require("jdtls").extract_method(true)
        end,
        mode = "v",
        desc = "Extract method",
      },
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
    "neovim/nvim-lspconfig",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "ray-x/lsp_signature.nvim",
        version = false,
        opts = function()
          local icons = require("config.icons")
          return {
            bind = true,
            hint_enable = false,
            hint_prefix = {
              above = "↙ ", -- when the hint is on the line above the current line
              current = "← ", -- when the hint is on the same line
              below = "↖ ", -- when the hint is on the line below the current line
            },
            hint_scheme = "NonText",
            floating_window = true,
            doc_lines = 2,
            transparency = 20,
            cursorhold_update = false,
            handler_opts = {
              border = icons.borders.outer.all,
            },
          }
        end,
      },
    },

    opts = {
      hover = {
        border = require("config.icons").borders.outer.all,
        max_width = 80,
        max_height = 25,
      },
      diagnostic = {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("config.icons").diagnostics.error,
            [vim.diagnostic.severity.WARN] = require("config.icons").diagnostics.warn,
            [vim.diagnostic.severity.HINT] = require("config.icons").diagnostics.hint,
            [vim.diagnostic.severity.INFO] = require("config.icons").diagnostics.info,
          },
        },
        virtual_text = false,
        -- virtual_lines = {
        --   current_line = false,
        --   format = function(diagnostic)
        --     if vim.wo.wrap then
        --       return nil
        --     end
        --
        --     if diagnostic.severity == vim.diagnostic.severity.ERROR then
        --       return diagnostic.message
        --     end
        --     return nil
        --   end,
        -- },
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
        severity_sort = true,
      },

      servers = {
        bashls = {},
        clangd = {},
        erlangls = {
          skip_install = true,
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
        jdtls = { skip_setup = true },
        texlab = {},
        basedpyright = {
          -- skip_install = true,
          settings = {
            verboseOutput = false,
            autoImportCompletion = true,
            basedpyright = {
              disableOrganizeImports = true,
              analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                indexing = true,
              },
            },
          },
        },
        zls = {},
        -- jedi_language_server = {
        --   capabilities = {
        --     textDocument = {
        --       completion = {
        --         completionItem = {
        --           snippetSupport = false,
        --         },
        --       },
        --     },
        --   },
        -- },
        lua_ls = {},
        jsonls = {},
        marksman = {},
        ruff = {
          on_attach = function(client, bufnr)
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.diagnosticProvider = false
          end,
        },
        rust_analyzer = {},
        yamlls = {},
      },
    },

    config = function(_, opts)
      -- Fix for bug https://github.com/neovim/neovim/issues/12970
      -- vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
      --   local text_document = text_document_edit.textDocument
      --   local buf = vim.uri_to_bufnr(text_document.uri)
      --   if offset_encoding == nil then
      --     vim.notify_once("apply_text_document_edit must be called with valid offset encoding", vim.log.levels.WARN)
      --   end
      --
      --   vim.lsp.util.apply_text_edits(text_document_edit.edits, buf, offset_encoding)
      -- end
      vim.diagnostic.config(opts.diagnostic)

      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      -- local capabilities = vim.lsp.protocol.make_client_capabilities() --require("cmp_nvim_lsp").default_capabilities()
      -- local capabilities =
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
        local options = {
          on_attach = config.on_attach,
          filetypes = config.filetypes,
          capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities or {}),
          settings = config.settings or {},
        }
        if config.filetypes ~= nil then
          options.filetypes = config.filetypes
        end
        if config.root_dir ~= nil then
          options.root_dir = config.root_dir
        end

        lspconfig[server].setup(options)
      end

      local hover = vim.lsp.with(vim.lsp.handlers.hover, opts.hover)
      vim.lsp.handlers["textDocument/hover"] = hover

      local manager = require("lspconfig.manager")
      -- silence warnings when an LSP binary is unavailable.
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
