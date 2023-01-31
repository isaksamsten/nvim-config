return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      dimInactive = true,
    },
    config = function(_, opts)
      local theme = require("kanagawa")
      theme.setup(opts)
      vim.cmd([[colorscheme kanagawa]])
    end,
  },

  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
    },
  },
}
