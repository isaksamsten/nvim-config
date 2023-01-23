return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },

  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      local theme = require("onedark")
      theme.setup(opts)
      vim.cmd([[colorscheme onedark]])
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
}
