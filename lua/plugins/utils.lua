return {
  { "tpope/vim-fugitive", event = "VeryLazy" },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    keys = function()
      local ui = require("harpoon.ui")
      local mark = require("harpoon.mark")
      return {
        { "<leader>k", ui.toggle_quick_menu, desc = "List marks" },
        { "<leader>a", mark.add_file, desc = "Mark file" },
        { "[§", ui.nav_prev, desc = "Previous mark" },
        { "]§", ui.nav_next, desc = "Next mark" },
        {
          "§",
          function()
            if vim.v.count == 0 then
              ui.nav_file(1)
            else
              ui.nav_file(vim.v.count)
            end
          end,
          desc = "Go to mark",
        },
      }
    end,
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
