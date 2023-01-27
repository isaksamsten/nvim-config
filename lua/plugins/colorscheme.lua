return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },

  {
    "navarasu/onedark.nvim",
  },

  { "EdenEast/nightfox.nvim" },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
    },
    config = function(_, opts)
      local theme = require("catppuccin")
      theme.setup(opts)
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
