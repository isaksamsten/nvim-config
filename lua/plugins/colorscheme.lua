return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {

      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      integrations = {
        aerial = true,
        cmp = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        mini = true,
        neogit = true,
        neotest = true,
        telescope = true,
        treesitter = true,
        treesitter_context = false,
        ts_rainbow = false,
        which_key = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },

    lazy = false,
    priority = 1000,
    config = function(_, opts)
      local theme = require("catppuccin")
      theme.setup(opts)
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "dark",
    },
  },
}
