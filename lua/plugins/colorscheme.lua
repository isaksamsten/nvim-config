return {
  {
    "isaksamsten/melange-nvim",
    dir = "~/Projects/melange-nvim/",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      vim.cmd([[colorscheme melange]])
    end,
  },
}
