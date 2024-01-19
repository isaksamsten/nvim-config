return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({})
        end,
        desc = "Format",
      },
    },
    opts = function()
      local ruff = {
        meta = {
          url = "https://beta.ruff.rs/docs/",
          description = "An extremely fast Python linter, written in Rust.",
        },
        command = "ruff",
        args = {
          "--fix",
          "-e",
          "-n",
          "--stdin-filename",
          "$FILENAME",
          "-",
        },
        stdin = true,
        cwd = require("conform.util").root_file({
          "pyproject.toml",
        }),
      }
      local latexindent = {
        meta = {
          url = "https://github.com/cmhughes/latexindent.pl",
          description = "A perl script for formatting LaTeX files that is generally included in major TeX distributions.",
        },
        command = "latexindent",
        args = {
          "-m",
          "-l",
          "-",
        },
        stdin = true,
      }
      local erlfmt = {
        meta = {
          url = "https://github.com/WhatsApp/erlfmt",
          description = "An opinionated Erlang code formatter.",
        },
        command = "erlfmt",
        args = { "-" },
        stdin = true,
      }
      local java_google_format = {
        meta = {
          url = "https://github.com/google/google-java-format",
          description = "google-java-format is a program that reformats Java source code to comply with Google Java Style.",
        },
        command = "google-java-format",
        args = { "-" },
        stdin = true,
      }
      return {
        formatters_by_ft = {
          ["*"] = { "trim_whitespace", "trim_newline" },
          python = { "ruff", "black" },
          tex = { "latexindent" },
          lua = { "stylua" },
          erlang = { "erlfmt" },
          java = { "java_google_format" },
          markdown = { "prettier" },
          json = { "prettier" },
        },
        formatters = {
          ruff = ruff,
          latexindent = latexindent,
          erlfmt = erlfmt,
          java_google_format = java_google_format,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters.numpydoc_lint = {
        cmd = "numpydoc-lint",
        stdin = true,
        stream = "stdout",
        args = {
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(
          [[(%d+):(%d+):(%d+):(%d+): ((%u)%w+) (.*)]],
          { "lnum", "col", "end_lnum", "end_col", "code", "severity", "message" },
          {
            E = vim.diagnostic.severity.ERROR,
            W = vim.diagnostic.severity.WARN,
            I = vim.diagnostic.severity.INFO,
            H = vim.diagnostic.severity.HINT,
          },
          { source = "numpydoc-lint" }
        ),
      }
      require("lint").linters.cython_lint = {
        cmd = "cython-lint",
        stdin = false,
        args = {},
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(
          [[(%d+):(%d+): ((%u)%w+) (.*)]],
          { "lnum", "col", "code", "severity", "message" },
          {
            E = vim.diagnostic.severity.ERROR,
            W = vim.diagnostic.severity.WARN,
          }
        ),
      }
      require("lint").linters_by_ft = {
        python = { "numpydoc_lint" },
        cython = { "cython_lint" },
        -- tex = { "vale" },
        -- markdown = { "vale" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        opts = function()
          return {
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",
            history = false,
          }
        end,
        config = function(_, opts)
          require("luasnip").setup(opts)

          -- Extend python and rst with corresponding snippets
          require("luasnip").filetype_extend("python", { "rst" })
          require("luasnip").filetype_extend("rst", { "python" })

          -- Unlink the snippet and restore completion
          -- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1011938524
          vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*",
            callback = function()
              if
                ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
                and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                and not require("luasnip").session.jump_active
              then
                require("luasnip").unlink_current()
                require("cmp.config").set_global({
                  completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
                })
              end
            end,
          })

          -- Do not automatically trigger completion if we are in a snippet
          vim.api.nvim_create_autocmd("User", {
            pattern = "LuaSnipInsertNodeEnter",
            callback = function()
              require("cmp.config").set_global({ completion = { autocomplete = false } })
            end,
          })

          -- But restore it when we leave.
          vim.api.nvim_create_autocmd("User", {
            pattern = "LuaSnipInsertNodeLeave",
            callback = function()
              require("cmp.config").set_global({
                completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
              })
            end,
          })
        end,
      },
      { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/snippets/" } })
        end,
      },
    },
    opts = function()
      local icons = require("config.icons")
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local prev_item = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      local next_item = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
      return {
        preselect = cmp.PreselectMode.None,
        completion = {
          -- completeopt = "menu,menuone,noinsert",
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
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
            border = icons.borders.outer.all,
            col_offset = 2,
            side_padding = 1,
            scrollbar = false,
          },

          documentation = {
            winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
            border = icons.borders.outer.all,
            side_padding = 0,
            scrollbar = false,
            max_width = 80,
            max_height = 25,
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local label = item.abbr
            local max_width = vim.g.cmp_completion_max_width or 30
            local truncated_label = vim.fn.strcharpart(label, 0, max_width - 1) -- 1 character for the elipsis
            if truncated_label ~= label then
              item.abbr = truncated_label .. "…"
            elseif string.len(label) < max_width then
              local padding = string.rep(" ", max_width - string.len(label))
              item.abbr = label .. padding
            end
            item.abbr = " " .. item.abbr
            item.menu = item.kind
            if entry.source.name == "omni" then
              item.kind = icons.kinds["Function"]
              item.menu = "Function"
            else
              item.kind = (icons.kinds[item.kind] or icons.kinds.Unknown)
            end
            return item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = { i = prev_item, c = prev_item },
          ["<C-j>"] = { i = next_item, c = next_item },
          ["<Up>"] = { i = prev_item, c = prev_item },
          ["<Down>"] = { i = next_item, c = next_item },
          ["<C-Space>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-u>"] = { i = cmp.mapping.scroll_docs(-4) },
          ["<C-d>"] = { i = cmp.mapping.scroll_docs(4) },
          ["<Tab>"] = {
            i = function(fallback)
              -- We dont autocomplete if we are in an active Snippet unless the completion
              -- item is selected explicitly.
              if cmp.visible() then
                cmp.confirm({ select = true })
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end,

            c = function(_)
              if cmp.visible() then
                cmp.confirm({ select = true })
              else
                cmp.complete()
              end
            end,
          },

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "otter" },
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
          { name = "luasnip", keyword_length = 2 },
        }),
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = opts.mapping,
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = opts.mapping,
        sources = cmp.config.sources({
          { name = "cmdline" },
        }, {
          { name = "path" },
        }),
      })

      require("cmp_git").setup()
      cmp.setup.filetype("gitcommit", {
        mapping = opts.mapping,
        sources = {
          { name = "git" },
        },
      })
      cmp.setup.cmdline("@", { enabled = false })
      cmp.setup.cmdline(">", { enabled = false })
      cmp.setup.cmdline("-", { enabled = false })
      cmp.setup.cmdline("=", { enabled = false })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        enabled = true,
        sources = {
          { name = "dap" },
        },
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run test",
      },
      {
        "<leader>tR",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run all tests",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test outputs",
      },
      {
        "<leader>tp", -- Shift-<F4>
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Peek test",
      },
    },
    opts = function()
      local icons = require("config.icons")
      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = require("helpers.python").executable,
          }),
        },
        icons = {
          child_indent = icons.indent.marker,
          child_prefix = icons.indent.prefix,
          collapsed = icons.indent.collapsed,
          expanded = icons.indent.expanded,
          failed = icons.test.failed,
          final_child_indent = " ",
          final_child_prefix = icons.indent.last,
          non_collapsible = icons.indent.collapsible,
          passed = icons.test.passed,
          running = icons.test.running,
          running_animated = icons.test.running_animated,
          skipped = icons.test.skipped,
          unknown = icons.test.unknown,
        },
        floating = {
          border = icons.borders.outer.all,
        },
        quickfix = {
          open = false,
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enabled = true,
      snippet_engine = "luasnip",
      languages = {
        python = { template = { annotation_convention = "numpydoc" } },
      },
    },
    keys = {
      {
        "<C-;>",
        function()
          require("neogen").generate()
        end,
        mode = { "n", "i" },
        desc = "Generate documentation",
      },
    },
  },
}
