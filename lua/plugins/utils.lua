return {

  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", desc = "Left window" },
      { "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", desc = "Up window" },
      { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", desc = "Down window" },
      { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", desc = "Right window" },
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
}
