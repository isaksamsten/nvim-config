return {
  {
    "isaksamsten/melange-nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      vim.cmd([[colorscheme melange]])
    end,
  },
}
