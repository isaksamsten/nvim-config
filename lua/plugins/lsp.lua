return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    opts = {
      root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
    },
    version = false,
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
        local root_dir = vim.fs.root(0, opts.root_markers or { ".git", "pom.xml", "build.gradle" })
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
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    version = false,
    enabled = false,
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
  {
    "neovim/nvim-lspconfig",
    version = false,
    lazy = true,
    init = function()
      local lspConfigPath = require("lazy.core.config").options.root .. "/nvim-lspconfig"
      vim.opt.runtimepath:append(lspConfigPath)
    end,
  },

  { "williamboman/mason.nvim", lazy = false },
}
