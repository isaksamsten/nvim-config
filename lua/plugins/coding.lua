vim.g.ai_no_mappings = true
return {
  {
    "aduros/ai.vim",
    config = function()
      vim.g.ai_temperature = 0.7
      vim.g.ai_indicator_text = "󱚠"

      vim.keymap.set("n", "<M-a>", ":AI ", { desc = "AI prompt" })
      vim.keymap.set("v", "<M-a>", ":AI ", { desc = "AI prompt" })
      vim.keymap.set("v", "zAc", ":AI Corrects sentences into standard English.<CR>", { desc = "Grammar check" })
      vim.keymap.set("i", "<M-a>", "<Esc>:AI<CR>a", { desc = "AI prompt" })
    end,
    lazy = false,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "VeryLazy" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
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
                require("cmp.config").global.completion.autocomplete =
                  { require("cmp.types").cmp.TriggerEvent.TextChanged }
              end
            end,
          })

          -- Do not automatically trigger completion if we are in a snippet
          vim.api.nvim_create_autocmd("User", {
            pattern = "LuaSnipInsertNodeEnter",
            callback = function()
              require("cmp.config").global.completion.autocomplete = false
            end,
          })

          -- But restore it when we leave.
          vim.api.nvim_create_autocmd("User", {
            pattern = "LuaSnipInsertNodeLeave",
            callback = function()
              require("cmp.config").global.completion.autocomplete =
                { require("cmp.types").cmp.TriggerEvent.TextChanged }
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
            winhighlight = "Normal:Pmenu,FloatBorder:PmenuDocBorder,CursorLine:PmenuSel,Search:None",
            border = icons.borders.outer.all,
            side_padding = 0,
            scrollbar = false,
            max_width = 80,
            max_height = 25,
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, item)
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
            item.kind = (icons.kinds[item.kind] or icons.kinds.Unknown)
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
          { name = "path" },
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "buffer", keyword_length = 3 },
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

      cmp.setup.filetype("gitcommit", {
        mapping = opts.mapping,
        sources = {
          { name = "git" },
        },
      })
      require("cmp_git").setup()
    end,
  },

  { "numToStr/Comment.nvim", event = "BufReadPost", config = true },

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
        desc = "Run tests in file",
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
        "<leader>to",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Show test summary",
      },
      {
        "<leader>t,",
        function()
          require("neotest").output.open({ enter = false })
        end,
        desc = "Reveal test",
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
