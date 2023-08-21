return {

  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", desc = "Left window" },
      { "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>" },
      { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>" },
      { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>" },
    },
    lazy = false,
    opts = {
      disable_when_zoomed = true,
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = "G",
    keys = { { "<leader>gg", "<cmd>G <CR>", desc = "Git status" } },
  },

  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    cond = require("helpers").is_remote,
    opts = {
      silent = true,
    },
    config = function(_, opts)
      require("osc52").setup(opts)
      local function copy()
        if vim.v.event.operator == "y" and (vim.v.event.regname == "" or vim.v.event.regname == "+") then
          require("osc52").copy_register("+")
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "\\M",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Show file marks",
      },
      {
        "\\m",
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
}
