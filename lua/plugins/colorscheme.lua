return {
  {
    "EdenEast/nightfox.nvim",
    opts = function()
      return {
        options = {
          terminal_colors = true,
          dim_inactive = true,
          module_default = true,
          styles = { -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "bold",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "bold",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = {
            diagnostic = {
              background = true,
            },
          },
        },
        palettes = {},
        groups = {
          all = {
            IndentBlanklineContextChar = { fg = "bg4" },
            DiagnosticVirtualTextError = { style = "italic" },
            DiagnosticVirtualTextWarn = { style = "italic" },
            DiagnosticVirtualTextInfo = { style = "italic" },
            DiagnosticVirtualTextHint = { style = "italic" },
          },
        },
      }
    end,
    lazy = false,
    priority = 999,
    config = function(_, opts)
      local theme = require("nightfox")
      theme.setup(opts)
      vim.cmd([[colorscheme duskfox]])
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- lazy = false,
    -- priority = 1000,
    opts = {
      highlight_overrides = {
        all = function(colors)
          return {
            IndentBlanklineContextChar = { fg = colors.surface1 },
            -- DiagnosticVirtualTextError = { bg = "NONE" },
            -- DiagnosticVirtualTextWarn = { bg = "NONE" },
            -- DiagnosticVirtualTextInfo = { bg = "NONE" },
            -- DiagnosticVirtualTextHint = { bg = "NONE" },
          }
        end,
      },
      flavour = "macchiato",
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
        background = true,
      },
    },
  },
}
