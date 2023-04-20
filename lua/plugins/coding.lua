vim.g.ai_no_mappings = true
return {
  {
    "aduros/ai.vim",
    config = function()
      vim.g.ai_temperature = 0.7
      vim.g.ai_indicator_text = "󱚠"

      vim.keymap.set("n", "<M-a>", ":AI ", { desc = "AI prompt" })
      vim.keymap.set("v", "<M-a>", ":AI ", { desc = "AI prompt" })
      vim.keymap.set("v", "gAc", ":AI Corrects sentences into standard English.<CR>", { desc = "Grammar check" })
      vim.keymap.set("i", "<M-a>", "<Esc>:AI<CR>a", { desc = "AI prompt" })
    end,
    lazy = false,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local prev_item = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      local next_item = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
      return {
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
          completion = {
            scrollbar = false,
          },
          documentation = {
            border = "solid",
            max_width = 80,
          },
        },
        formatting = {
          fields = { "abbr", "kind" },
          format = function(_, item)
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, 30)
            if truncated_label ~= label then
              item.abbr = truncated_label .. "..."
            elseif string.len(label) < 30 then
              local padding = string.rep(" ", 30 - string.len(label))
              item.abbr = label .. padding
            end
            local icons = require("config.icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            item.menu = nil
            return item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = { i = prev_item, c = prev_item },
          ["<C-j>"] = { i = next_item, c = next_item },
          ["<Up>"] = { i = prev_item, c = prev_item },
          ["<Down>"] = { i = next_item, c = next_item },
          ["<Tab>"] = {
            i = cmp.mapping.confirm({ select = true }),
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm({ select = true })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-e>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<C-p>"] = { i = cmp.mapping.scroll_docs(-4) },
          ["<C-n>"] = { i = cmp.mapping.scroll_docs(4) },
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
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
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
      "antoinemadec/FixCursorHold.nvim",
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
          require("neotest").output.open({ enter = true })
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
        desc = "Generate documentation",
      },
    },
  },
}
