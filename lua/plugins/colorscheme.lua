return {

  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
    },
    config = function(_, opts)
      local theme = require("onedark")
      theme.setup(opts)
      vim.cmd([[colorscheme onedark]])
    end,
  },
}
