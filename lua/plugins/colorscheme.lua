return {
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
