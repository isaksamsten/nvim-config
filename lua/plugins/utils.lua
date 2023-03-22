return {
  { "tpope/vim-fugitive", event = "VeryLazy" },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    keys = {
      {
        "<leader>k",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "List marks",
      },
      {
        "<leader>a",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Mark file",
      },
      {
        "[§",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Previous mark",
      },
      {
        "]§",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Next mark",
      },
      {
        "§",
        function()
          if vim.v.count == 0 then
            require("harpoon.ui").nav_file(1)
          else
            require("harpoon.ui").nav_file(vim.v.count)
          end
        end,
        desc = "Go to mark",
      },
    },
  },
  -- {
  --   "TimUntersberger/neogit",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = function(_, keys)
  --     return {
  --       {
  --         "<leader>hh",
  --         function()
  --           return require("neogit").open()
  --         end,
  --         desc = "Open neogit",
  --       },
  --     }
  --   end,
  --   config = true,
  -- },
}
