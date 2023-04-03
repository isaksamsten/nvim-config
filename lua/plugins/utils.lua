return {
  { "tpope/vim-fugitive", event = "VeryLazy" },

  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    cond = function()
      return os.getenv("SSH_CLIENT") ~= nil
    end,
    config = function(_, opts)
      function copy()
        if vim.v.event.operator == "y" and (vim.v.event.regname == "" or vim.v.event.regname == "+") then
          require("osc52").copy_register("+")
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    keys = {
      {
        "<leader>k",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Show file marks",
      },
      {
        "<leader>a",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Add file mark",
      },
      {
        "[§",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Previous file mark",
      },
      {
        "]§",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Next file mark",
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
        desc = "Go to file mark",
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
