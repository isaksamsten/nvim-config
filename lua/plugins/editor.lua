return { -- TODO
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    keys = { { "<leader>ou", "<cmd>MundoToggle<cr>", desc = "Undo history" } },
  },

  {
    "ggandor/leap.nvim",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("leap").add_default_mappings()
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branc for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>z",
        -- insert_line = "gC-ggZ",
        normal = "gz",
        normal_cur = "gZ",
        normal_line = "gzz",
        normal_cur_line = "gZZ",
        visual = "gz",
        visual_line = "gZ",
        delete = "gzd",
        change = "gzr",
      },
    },
  },
  {
    "echasnovski/mini.hipatterns",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local function in_comment(marker)
        local comment_chars = {
          java = "//",
          rust = "//",
          cpp = "//",
          c = "//",
          python = "#",
          bash = "#",
          lua = "--",
          tex = "%",
        }
        return function(bufnr)
          local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
          local comment_char = comment_chars[filetype]

          if comment_char then
            return comment_char .. " ()" .. marker .. "()%f[%W]"
          else
            return nil
          end
        end
      end

      local function markdown_title(level)
        local prefix = string.rep("#", level)
        return function(bufnr)
          local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
          if filetype ~= "markdown" then
            return nil
          end

          return "^" .. prefix .. "%s+.*$"
        end
      end
      return {
        highlighters = {
          fixme = { pattern = in_comment("FIXME"), group = "DiagnosticSignError" },
          hack = { pattern = in_comment("HACK"), group = "DiagnosticSignInfo" },
          todo = { pattern = in_comment("TODO"), group = "DiagnosticSignWarn" },
          note = { pattern = in_comment("NOTE"), group = "DiagnosticSignHint" },
          md1 = { pattern = markdown_title(1), group = "Headline1" },
          md2 = { pattern = markdown_title(2), group = "Headline2" },
          md3 = { pattern = markdown_title(3), group = "Headline3" },
          md4 = { pattern = markdown_title(4), group = "Headline4" },
          md5 = { pattern = markdown_title(5), group = "Headline5" },
          md6 = { pattern = markdown_title(6), group = "Headline6" },
        },
      }
    end,
  },
  {
    "echasnovski/mini.move",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },

  {
    "echasnovski/mini.ai",
    event = "BufReadPost",
    version = false,
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = function()
      local icons = require("config.icons")
      return {
        padding = false,
        use_diagnostic_signs = true,
        fold_open = icons.folder.expanded, -- icon used for open folds
        fold_closed = icons.folder.collapsed,
        action_keys = { -- key mappings for actions in the trouble list
          open_split = { "s" }, -- open buffer in new split
          open_vsplit = { "v" }, -- open buffer in new vsplit
          open_tab = { "t" }, -- open buffer in new tab
          jump_close = { "o" }, -- jump to the diagnostic and close the list
          toggle_mode = {}, -- toggle between "workspace" and "document" diagnostics mode
        },
      }
    end,
    keys = {
      { "<leader>od", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>oD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>ol", "<cmd>TroubleToggle loclist<cr>", desc = "Location" },
      { "<leader>oq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
      {
        "[,",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            -- local ok, result = pcall(vim.cmd, "cprev")
            -- if not ok then
            --   ok, result = pcall(vim.cmd, "clast")
            --   if not ok then
            vim.diagnostic.goto_prev()
            --   end
            -- end
          end
        end,
        desc = "Previous trouble",
      },
      {
        "],",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            -- local ok, result = pcall(vim.cmd, "cnext")
            -- if not ok then
            --   ok, result = pcall(vim.cmd, "cfirst")
            --   if not ok then
            vim.diagnostic.goto_next()
            --   end
            -- end
          end
        end,
        desc = "Next trouble",
      },
    },
  },
}
