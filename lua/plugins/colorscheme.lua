return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "moon" },
    config = function(_, opts)
      local theme = require("tokyonight")
      theme.setup(opts)
      theme.load()
    end,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "darker" },
  },
}
