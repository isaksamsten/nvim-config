return {
  -- Too buggy
  -- {
  --   "ThePrimeagen/refactoring.nvim",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-treesitter/nvim-treesitter" },
  --   },
  --   keys = {
  --     {
  --       "<leader>rf",
  --       function()
  --         require("refactoring").refactor("Extract Function")
  --       end,
  --       mode = "v",
  --       desc = "Extract function",
  --       silent = true,
  --       expr = false,
  --     },
  --     {
  --       "<leader>rv",
  --       function()
  --         require("refactoring").refactor("Extract Variable")
  --       end,
  --       mode = "v",
  --       desc = "Extract variable",
  --       silent = true,
  --       expr = false,
  --     },
  --     {
  --       "<leader>ri",
  --       function()
  --         require("refactoring").refactor("Inline Variable")
  --       end,
  --       mode = { "v", "n" },
  --       desc = "Inline variable",
  --       silent = true,
  --       expr = false,
  --     },
  --     {
  --       "<leader>rb",
  --       function()
  --         require("refactoring").refactor("Extract Block")
  --       end,
  --       desc = "Extact block",
  --       silent = true,
  --       expr = false,
  --     },
  --     {
  --       "<leader>rr",
  --       function()
  --         require("refactoring").select_refactor()
  --       end,
  --       mode = { "n", "v" },
  --       desc = "Refactor",
  --       silent = true,
  --       expr = false,
  --     },
  --   },
  -- },

  { "numToStr/Comment.nvim", event = "BufReadPost", config = true },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
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
    config = function(opts)
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = require("helpers.python").executable,
          }),
        },
      })
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
