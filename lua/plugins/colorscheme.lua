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
    opts = function()
      local Color = require("helpers.color")
      local overrides = function(lighten, darken)
        local function override(colors)
          local fg_border = lighten(colors.base, 3)
          local telescope_prompt = darken(colors.base, 3)
          local telescope_results = darken(colors.base, 4)
          local telescope_preview = darken(colors.base, 6)
          local telescope_selection = darken(colors.base, 8)
          local faded_yellow = Color.mix(colors.base, colors.yellow, 0.1)
          local faded_red = Color.mix(colors.base, colors.red, 0.1)
          local faded_purple = Color.mix(colors.base, colors.mauve, 0.1)
          local neotree_cursorline_bg = Color.mix(colors.mantle, colors.text, 0.01)

          local gray = colors.subtext0
          local fg = colors.text
          local purple = colors.mauve
          local green = colors.green
          local blue = colors.blue
          local yellow = colors.yellow
          local red = colors.red
          local cyan = colors.sky
          local float_bg = colors.mantle

          return {
            IndentBlanklineContextChar = { fg = colors.surface1 },
            IndentBlanklineChar = { fg = colors.surface1 },

            TelescopeBorder = {
              fg = telescope_results,
              bg = telescope_results,
            },
            TelescopePromptBorder = {
              fg = telescope_prompt,
              bg = telescope_prompt,
            },
            TelescopePromptCounter = { fg = fg },
            TelescopePromptNormal = { fg = fg, bg = telescope_prompt },
            TelescopePromptPrefix = {
              fg = purple,
              bg = telescope_prompt,
            },
            TelescopePromptTitle = {
              fg = telescope_prompt,
              bg = purple,
            },
            TelescopePreviewTitle = {
              fg = telescope_results,
              bg = green,
            },
            TelescopeResultsTitle = {
              fg = telescope_results,
              bg = telescope_results,
            },
            TelescopeMatching = { fg = blue },
            TelescopeNormal = { bg = telescope_results },
            TelescopeSelection = { bg = telescope_selection },
            TelescopePreviewNormal = { bg = telescope_preview },
            TelescopePreviewBorder = { fg = telescope_preview, bg = telescope_preview },
            NeoTreeCursorLine = { bg = neotree_cursorline_bg, bold = true },
            NeoTreeTabActive = { bg = colors.mantle, bold = true },
            NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
            NeoTreeTabInactive = { bg = colors.mantle, fg = colors.overlay0 },
            NeoTreeTabSeparatorInactive = { fg = colors.mantle, bg = colors.mantle },
            NeoTreeNormal = { fg = colors.text, bg = colors.mantle },
            NeoTreeNormalNC = { fg = colors.text, bg = colors.mantle },

            LineNr = { fg = colors.overlay0 },
            CursorLineNr = { fg = colors.lavender, bold = true },
            -- Cmp
            CmpItemAbbrMatch = { fg = blue, bold = true },
            CmpItemAbbrMatchFuzzy = { fg = blue, underline = true },
            CmpItemMenu = { fg = colors.surface1, italic = true },
            -- CmpItemAbbr = { fg = colors.surface2 },

            -- Neotest
            NeotestAdapterName = { fg = purple, bold = true },
            NeotestFocused = { bold = true },
            NeotestNamespace = { fg = blue, bold = true },

            -- Neotree
            NeoTreeRootName = { fg = purple, bold = true },
            NeoTreeFileNameOpened = { fg = purple, italic = true },

            -- DAP
            -- DebugBreakpoint = { fg = "${red}", bold = true },
            -- DebugHighlightLine = { fg = "${purple}", italic = true },
            NvimDapVirtualText = { fg = cyan, italic = true },

            -- DAP UI
            DapUIBreakpointsCurrentLine = { fg = yellow, bold = true },

            DiagnosticUnderlineError = { sp = red, undercurl = true },
            DiagnosticUnderlineWarn = { sp = yellow, undercurl = true },
            DiagnosticUnderlineInfo = { sp = blue, undercurl = true },
            DiagnosticUnderlineHint = { sp = cyan, undercurl = true },

            DiagnosticFloatingSuffix = { fg = gray },
            DiagnosticFloatingHint = { fg = fg },
            DiagnosticFloatingWarn = { fg = fg },
            DiagnosticFloatingInfo = { fg = fg },
            DiagnosticFloatingError = { fg = fg },

            -- ModeMsg = { fg = fg, bg = float_bg },
            -- MsgArea = { fg = fg, bg = float_bg },

            NoiceMini = { link = "NonText" },
            NoiceVirtualText = { link = "NonText" },
            NoiceCmdline = { fg = fg, bg = colors.mantle },
            NoiceCmdlinePopup = { link = "PopupNormal" },
            NoiceCmdlinePopupBorder = { link = "PopupBorder" },
            NoiceCmdlinePrompt = { link = "PopupNormal" },
            NoiceConfirm = { link = "PopupNormal" },
            NoiceConfirmBorder = { link = "PopupBorder" },

            AIHighlight = { link = "NonText" },
            AIIndicator = { link = "DiagnosticSignInfo" },

            PopupNormal = { bg = float_bg },
            PopupBorder = { bg = float_bg, fg = fg_border },
            Pmenu = { link = "PopupNormal" },
            PmenuSel = { bold = true, bg = "none" },
            PmenuBorder = { link = "PopupBorder" },
            PmenuDocBorder = { bg = float_bg, fg = fg_border },
            NormalFloat = { bg = float_bg },
            FloatBorder = { bg = float_bg, fg = fg_border },
            FloatTitle = { fg = colors.lavender, bg = float_bg },
            BqfPreviewBorder = { link = "PopupBorder" },
            BqfPreviewFloat = { link = "PopupNormal" },
            DebugLogPoint = { fg = purple, bg = faded_purple },
            DebugLogPointLine = { fg = purple, bg = faded_purple },
            DebugStopped = { fg = yellow, bg = faded_yellow },
            DebugStoppedLine = { fg = yellow, bg = faded_yellow },
            DebugBreakpoint = { fg = red, bg = faded_red },
            DebugBreakpointLine = { fg = red, bg = faded_red },
            WinSeparator = { fg = colors.mantle, bg = colors.mantle },

            StatusColumnSeparator = { fg = colors.surface0, bg = "NONE" },
            SignColumn = { fg = colors.surface0 },

            TabLineHead = { bg = blue, fg = colors.base },
            TabLineFill = { bg = colors.mantle, fg = gray },
            TabLine = { bg = colors.mantle, fg = gray },
            TabLineSel = { bg = colors.mantle, fg = fg, bold = true },

            NotifyERRORBorder = { link = "PopupBorder" },
            NotifyWARNBorder = { link = "PopupBorder" },
            NotifyINFOBorder = { link = "PopupBorder" },
            NotifyDEBUGBorder = { link = "PopupBorder" },
            NotifyTRACEBorder = { link = "PopupBorder" },
            NotifyERRORIcon = { link = "DiagnosticSignError" },
            NotifyWARNIcon = { link = "DiagnosticSignWarn" },
            NotifyINFOIcon = { link = "DiagnosticSignInfo" },
            NotifyDEBUGIcon = { link = "DiagnosticSignInfo" },
            NotifyTRACEIcon = { link = "DiagnosticSignInfo" },
            NotifyERRORTitle = { fg = colors.text, bold = true },
            NotifyWARNTitle = { fg = colors.text, bold = true },
            NotifyINFOTitle = { fg = colors.text, bold = true },
            NotifyDEBUGTitle = { fg = colors.text, bold = true },
            NotifyTRACETitle = { fg = colors.text, bold = true },
            NotifyERRORBody = { link = "NormalFloat" },
            NotifyWARNBody = { link = "NormalFloat" },
            NotifyINFOBody = { link = "NormalFloat" },
            NotifyDEBUGBody = { link = "NormalFloat" },
            NotifyTRACEBody = { link = "NormalFloat" },
          }
        end
        return override
      end

      return {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "macchiato",
        },
        transparent_background = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = true,
        styles = {
          comments = { "italic" },
          conditionals = {},
          loops = {},
          functions = { "bold" },
          keywords = { "bold" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = { "bold" },
          operators = {},
        },
        color_overrides = {},
        highlight_overrides = {
          mocha = overrides(Color.lighten, Color.darken),
          macchiato = overrides(Color.lighten, Color.darken),
          frappe = overrides(Color.lighten, Color.darken),
          latte = overrides(Color.darken, Color.darken),
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
          mini = true,
          markdown = true,
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
      }
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    opts = function()
      local function blend(a, b, amount, theme)
        local Color = require("onedarkpro.lib.color")
        local Helper = require("onedarkpro.helpers")
        if theme then
          a = Color.from_hex(Helper.get_preloaded_colors(theme)[a])
          b = Color.from_hex(Helper.get_preloaded_colors(theme)[b])
          return a:blend(b, amount):to_css()
        end
        return Color.from_hex(a):blend(b, amount):to_css()
      end

      return {
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
          fg_border = "require('onedarkpro.helpers').lighten('bg', 3, 'onedark')",
          telescope_prompt = "require('onedarkpro.helpers').darken('bg', 3, 'onedark')",
          telescope_results = "require('onedarkpro.helpers').darken('bg', 4, 'onedark')",
          telescope_preview = "require('onedarkpro.helpers').darken('bg', 6, 'onedark')",
          telescope_selection = "require('onedarkpro.helpers').darken('bg', 8, 'onedark')",
          faded_yellow = blend("bg", "yellow", 0.1, "onedark"),
          faded_red = blend("bg", "red", 0.1, "onedark"),
        },
        highlights = {
          IndentBlanklineContextChar = { fg = "${fg_context_char}" },
          IndentBlanklineChar = { fg = "${fg_context_char}" },
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

          NeoTreeTabActive = { bg = "${telescope_prompt}" },
          NeoTreeTabSeparatorActive = { fg = "${telescope_prompt}", bg = "${telescope_prompt}" },
          NeoTreeTabInactive = { fg = "${gray}", bg = "${telescope_prompt}" },
          NeoTreeTabSeparatorInactive = { fg = "${telescope_prompt}", bg = "${telescope_prompt}" },
          NeoTreeNormal = { link = "TelescopeNormal" },
          NeoTreeNormalNC = { link = "TelescopeNormal" },

          -- Cmp
          CmpItemAbbrMatch = { fg = "${blue}", style = "bold" },
          CmpItemMenu = { link = "NonText" },
          CmpItemAbbrMatchFuzzy = { fg = "${blue}", style = "underline" },

          -- Neotest
          NeotestAdapterName = { fg = "${purple}", style = "bold" },
          NeotestFocused = { style = "bold" },
          NeotestNamespace = { fg = "${blue}", style = "bold" },

          -- Neotree
          NeoTreeRootName = { fg = "${purple}", style = "bold" },
          NeoTreeFileNameOpened = { fg = "${purple}", style = "italic" },

          -- DAP
          -- DebugBreakpoint = { fg = "${red}", style = "bold" },
          -- DebugHighlightLine = { fg = "${purple}", style = "italic" },
          NvimDapVirtualText = { fg = "${cyan}", style = "italic" },

          -- DAP UI
          DapUIBreakpointsCurrentLine = { fg = "${yellow}", style = "bold" },

          DiagnosticUnderlineError = { sp = "${red}", style = "undercurl" },
          DiagnosticUnderlineWarn = { sp = "${yellow}", style = "undercurl" },
          DiagnosticUnderlineInfo = { sp = "${blue}", style = "undercurl" },
          DiagnosticUnderlineHint = { sp = "${cyan}", style = "undercurl" },

          DiagnosticFloatingSuffix = { fg = "${gray}" },
          DiagnosticFloatingHint = { fg = "${fg}" },
          DiagnosticFloatingWarn = { fg = "${fg}" },
          DiagnosticFloatingInfo = { fg = "${fg}" },
          DiagnosticFloatingError = { fg = "${fg}" },

          -- ModeMsg = { fg = "${fg}", bg = "${telescope_prompt}" },
          NoiceMini = { link = "BetterVirtualTextInfo" },
          NoiceVirtualText = { link = "BetterVirtualTextInfo" },

          AIHighlight = { link = "NonText" },
          AIIndicator = { link = "DiagnosticSignInfo" },
          PopupNormal = { bg = "${float_bg}" },
          PopupBorder = { bg = "${float_bg}", fg = "${fg_border}" },
          Pmenu = { link = "PopupNormal" },
          PmenuSel = { style = "bold" },
          PmenuBorder = { link = "PopupBorder" },
          PmenuDocBorder = { bg = "${float_bg}", fg = "${fg_border}" },
          NormalFloat = { bg = "${float_bg}" },
          FloatBorder = { bg = "${float_bg}", fg = "${fg_border}" },
          DebugLogPoint = { fg = "${purple}" },
          DebugStopped = { fg = "${yellow}" },
          DebugStoppedLine = { bg = "${faded_yellow}" },
          DebugBreakpointRejected = { fg = "${purple}" },
          DebugBreakpoint = { fg = "${red}" },
          DebugBreakpointLine = { bg = "${faded_red}" },
          WinSeparator = { fg = "${telescope_prompt}", bg = "${telescope_prompt}" },
          StatusColumnSeparator = { fg = "${gray}", bg = "none" },
          TabLineFill = { bg = "${telescope_prompt}", fg = "${gray}" },
          TabLine = { bg = "${telescope_prompt}", fg = "${gray}" },
          TabLineSel = { bg = "${telescope_prompt}", fg = "${fg}", style = "bold" },
          TabLineHead = { bg = "${blue}", fg = "${telescope_prompt}" },

          NotifyERRORBorder = { link = "PopupBorder" },
          NotifyWARNBorder = { link = "PopupBorder" },
          NotifyINFOBorder = { link = "PopupBorder" },
          NotifyDEBUGBorder = { link = "PopupBorder" },
          NotifyTRACEBorder = { link = "PopupBorder" },
          NotifyERRORIcon = { link = "DiagnosticSignError" },
          NotifyWARNIcon = { link = "DiagnosticSignWarn" },
          NotifyINFOIcon = { link = "DiagnosticSignInfo" },
          NotifyDEBUGIcon = { link = "DiagnosticSignInfo" },
          NotifyTRACEIcon = { link = "DiagnosticSignInfo" },
          NotifyERRORTitle = { fg = "${fg}", style = "bold" },
          NotifyWARNTitle = { fg = "${fg}", style = "bold" },
          NotifyINFOTitle = { fg = "${fg}", style = "bold" },
          NotifyDEBUGTitle = { fg = "${fg}", style = "bold" },
          NotifyTRACETitle = { fg = "${fg}", style = "bold" },
          NotifyERRORBody = { link = "NormalFloat" },
          NotifyWARNBody = { link = "NormalFloat" },
          NotifyINFOBody = { link = "NormalFloat" },
          NotifyDEBUGBody = { link = "NormalFloat" },
          NotifyTRACEBody = { link = "NormalFloat" },
        },
        options = {
          cursorline = false,
          highlight_inactive_windows = false,
        },
      }
    end,
  },
}
