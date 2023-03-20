return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      local theme = require("catppuccin")
      theme.setup(opts)
      vim.cmd([[colorscheme catppuccin]])
    end,
    opts = {
      highlight_overrides = {
        all = function(colors)
          return {
            IndentBlanklineContextChar = { fg = colors.surface1 },
          }
        end,
      },
      flavour = "frappe",
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
        fidget = true,
        mason = true,
        mini = true,
        neogit = true,
        neotest = true,
        telescope = true,
        treesitter = true,
        treesitter_context = false,
        ts_rainbow = false,
        which_key = true,
        navic = {
          enabled = false,
          custom_bg = "NONE",
        },
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
  },

  {
    "navarasu/onedark.nvim",
    opts = {
      diagnostics = {
        darker = true,
        undercurl = true,
        background = false,
      },
    },
  },
}
