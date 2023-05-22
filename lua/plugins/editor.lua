return {
  {
    "ggandor/leap.nvim",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("leap").add_default_mappings()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branc for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>z",
        -- insert_line = "gC-ggZ",
        normal = "gz",
        normal_cur = "gZ",
        normal_line = "gzz",
        normal_cur_line = "gZZ",
        visual = "gz",
        visual_line = "gZ",
        delete = "gzd",
        change = "gzr",
      },
    },
  },

  {
    "echasnovski/mini.move",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },

  {
    "echasnovski/mini.ai",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<M-,>", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<M-<>", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>ol", "<cmd>TroubleToggle loclist<cr>", desc = "Location" },
      { "<leader>oq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
      {
        "[,",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            -- local ok, result = pcall(vim.cmd, "cprev")
            -- if not ok then
            --   ok, result = pcall(vim.cmd, "clast")
            --   if not ok then
            vim.diagnostic.goto_prev()
            --   end
            -- end
          end
        end,
        desc = "Previous trouble",
      },
      {
        "],",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            -- local ok, result = pcall(vim.cmd, "cnext")
            -- if not ok then
            --   ok, result = pcall(vim.cmd, "cfirst")
            --   if not ok then
            vim.diagnostic.goto_next()
            --   end
            -- end
          end
        end,
        desc = "Next trouble",
      },
    },
  },
}
