return {
  {
    "folke/tokyonight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      light_style = "day", -- The theme is used when the background is set to light
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors) end,
    },
  },
  {
    "olimorris/onedarkpro.nvim",
    opts = {
      styles = {
        types = "bold",
        methods = "bold",
        numbers = "NONE",
        strings = "NONE",
        comments = "italic",
        keywords = "bold",
        constants = "NONE",
        functions = "NONE",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "NONE",
        virtual_text = "italic",
      },
      plugins = {
        aerial = false,
        barbar = false,
        copilot = false,
        dashboard = false,
        hop = false,
        leap = false,
        lsp_saga = false,
        marks = false,
        nvim_hlslens = false,
        nvim_navic = false,
        nvim_notify = false,
        nvim_tree = false,
        nvim_ts_rainbow = false,
        op_nvim = false,
        packer = false,
        polygot = false,
        startify = false,
        vim_ultest = false,
      },
      colors = {
        fg_context_char = "require('onedarkpro.helpers').lighten('bg', 18, 'onedark')",
        telescope_prompt = "require('onedarkpro.helpers').darken('bg', 3, 'onedark')",
        telescope_results = "require('onedarkpro.helpers').darken('bg', 4, 'onedark')",
        telescope_preview = "require('onedarkpro.helpers').darken('bg', 6, 'onedark')",
        telescope_selection = "require('onedarkpro.helpers').darken('bg', 8, 'onedark')",
      },
      highlights = {
        IndentBlanklineContextChar = { fg = "${fg_context_char}" },
        ["@include.python"] = { fg = "${purple}", style = "bold" },
        ["@variable"] = { fg = "${fg}" },
        ["@lsp.type.function"] = { link = "@function" },

        TelescopeBorder = {
          fg = "${telescope_results}",
          bg = "${telescope_results}",
        },
        TelescopePromptBorder = {
          fg = "${telescope_prompt}",
          bg = "${telescope_prompt}",
        },
        TelescopePromptCounter = { fg = "${fg}" },
        TelescopePromptNormal = { fg = "${fg}", bg = "${telescope_prompt}" },
        TelescopePromptPrefix = {
          fg = "${purple}",
          bg = "${telescope_prompt}",
        },
        TelescopePromptTitle = {
          fg = "${telescope_prompt}",
          bg = "${purple}",
        },
        TelescopePreviewTitle = {
          fg = "${telescope_results}",
          bg = "${green}",
        },
        TelescopeResultsTitle = {
          fg = "${telescope_results}",
          bg = "${telescope_results}",
        },
        TelescopeMatching = { fg = "${blue}" },
        TelescopeNormal = { bg = "${telescope_results}" },
        TelescopeSelection = { bg = "${telescope_selection}" },
        TelescopePreviewNormal = { bg = "${telescope_preview}" },
        TelescopePreviewBorder = { fg = "${telescope_preview}", bg = "${telescope_preview}" },

        NeoTreeTabActive = { bg = "${telescope_preview}" },
        NeoTreeTabSeparatorActive = { fg = "${telescope_preview}", bg = "${telescope_preview}" },
        NeoTreeTabInactive = { bg = "${telescope_results}" },
        NeoTreeTabSeparatorInactive = { fg = "${telescope_results}", bg = "${telescope_results}" },

        -- Cmp
        CmpItemAbbrMatch = { fg = "${blue}", style = "bold" },
        CmpItemAbbrMatchFuzzy = { fg = "${blue}", style = "underline" },

        -- Neotest
        NeotestAdapterName = { fg = "${purple}", style = "bold" },
        NeotestFocused = { style = "bold" },
        NeotestNamespace = { fg = "${blue}", style = "bold" },

        -- Neotree
        NeoTreeRootName = { fg = "${purple}", style = "bold" },
        NeoTreeFileNameOpened = { fg = "${purple}", style = "italic" },

        -- DAP
        DebugBreakpoint = { fg = "${red}", style = "bold" },
        DebugHighlightLine = { fg = "${purple}", style = "italic" },
        NvimDapVirtualText = { fg = "${cyan}", style = "italic" },

        -- DAP UI
        DapUIBreakpointsCurrentLine = { fg = "${yellow}", style = "bold" },

        DiagnosticUnderlineError = { sp = "${red}", style = "undercurl" },
        DiagnosticUnderlineWarn = { sp = "${yellow}", style = "undercurl" },
        DiagnosticUnderlineInfo = { sp = "${blue}", style = "undercurl" },
        DiagnosticUnderlineHint = { sp = "${cyan}", style = "undercurl" },
        NoiceCmdline = { bg = "#23262c" },
        NoiceMini = { link = "BetterVirtualTextInfo" },
        NoiceVirtualText = { link = "BetterVirtualTextInfo" },
      },
      options = {
        cursorline = true,
        highlight_inactive_windows = true,
      },
    },
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      local theme = require("onedarkpro")
      theme.setup(opts)
      vim.cmd([[colorscheme onedark]])
    end,
  },
}
