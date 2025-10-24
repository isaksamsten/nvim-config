return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    opts = {
      suggestion = {
        enabled = false,
      },
      panel = { enabled = false },
    },
  },
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
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
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
      require("conform").formatters.latexindent = {
        prepend_args = { "-m", "-l" },
      }
      return {
        formatters_by_ft = {
          ["*"] = { "trim_whitespace", "trim_newline" },
          python = { "ruff_fix", "ruff_format" },
          tex = { "latexindent" },
          lua = { "stylua" },
          erlang = { "erlfmt" },
          java = { "java_google_format" },
          markdown = { "prettier" },
          json = { "prettier" },
          c = { "clang_format" },
          rust = { "rustfmt" },
          zig = { "zigfmt" },
          typ = { "typstyle" },
        },
        formatters = {
          erlfmt = erlfmt,
          java_google_format = java_google_format,
          clang_format = {
            prepend_args = { "--style=file", "--fallback-style=LLVM" },
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters.numpydoc_lint = {
        name = "numpydoc_lint",
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
        name = "cython_lint",
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
          -- require("lint").try_lint()
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "1.*",
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      cmdline = {
        enabled = false,
      },
      keymap = { preset = "super-tab" },
      completion = {
        accept = {
          auto_brackets = { enabled = false },
        },
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        trigger = { show_in_snippet = false },
        ghost_text = { enabled = true },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
      },
      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer" }
          else
            return { "lsp", "path", "snippets", "buffer" }
          end
        end,
        providers = {
          snippets = {
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
          },
        },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
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
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug test",
      },
      {
        "<leader>tS",
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
        desc = "Toggle test summary panel",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle test output panel",
      },
      {
        "<leader>tp",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Peek test",
      },
      {
        "[n",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Previous failed test",
      },
      {
        "]n",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next failed test",
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
          require("neotest-rust"),
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
          open = true,
        },
        summary = {
          mappings = { expand = { "<CR>", "l" }, jumpto = { "i", "L" } },
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
    enabled = false,
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
