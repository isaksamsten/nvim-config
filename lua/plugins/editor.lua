return { -- TODO
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    version = false,
    enabled = false,
    opts = {},
    config = function(_, opts)
      require("leap").add_default_mappings()
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      highlight = { backdrop = false },
      modes = {
        char = {
          enabled = false,
        },
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          -- show labeled treesitter nodes around the cursor
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          -- jump to a remote location to execute the operator
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "n", "o", "x" },
        function()
          -- show labeled treesitter nodes around the search matches
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branc for the latest features
    event = { "ModeChanged" },
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
    enabled = false,
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
}
