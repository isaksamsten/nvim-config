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
    "echasnovski/mini.surround",
    event = "BufReadPost",
    version = false,
    opts = {
      mappings = {
        add = "zsa", -- Add surrounding in Normal and Visual modes
        delete = "zsd", -- Delete surrounding
        find = "zsf", -- Find surrounding (to the right)
        find_left = "zsF", -- Find surrounding (to the left)
        highlight = "zsh", -- Highlight surrounding
        replace = "zsr", -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`

        suffix_last = "", -- Suffix to search with "prev" method
        suffix_next = "", -- Suffix to search with "next" method
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
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
      { "<leader>,", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Show document diagnostics" },
      { "<leader><", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Show workspace diagnostics" },
      { "<leader>L", "<cmd>TroubleToggle loclist<cr>", desc = "Show location list" },
      { "<leader>U", "<cmd>TroubleToggle quickfix<cr>", desc = "Show quickfix list" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, result = pcall(vim.cmd, "cprev")
            if not ok then
              ok, result = pcall(vim.cmd, "clast")
              if not ok then
                print("No errors")
              end
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, result = pcall(vim.cmd, "cnext")
            if not ok then
              ok, result = pcall(vim.cmd, "cfirst")
              if not ok then
                print("No errors")
              end
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}
