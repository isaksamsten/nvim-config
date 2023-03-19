-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {

  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },

  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
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
      { "<leader>m", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "<leader>M", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>l", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
      { "<leader>u", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
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
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}
