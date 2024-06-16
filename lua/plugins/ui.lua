return {
  {
    "romainl/vim-qf",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:qf_mapping_ack_style = 1
        nmap <C-S-q> <Plug>qf_qf_toggle
        nmap <C-q> <Plug>qf_qf_switch

        nmap [q <Plug>qf_qf_previous
        nmap ]q  <Plug>qf_qf_next
      ]])
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufNewFile", "BufReadPre" },
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        relculright = true,
        setopt = true,
        segments = {
          {
            sign = {
              name = {
                "Dap",
                "neotest",
              },
              maxwidth = 2,
              colwidth = 2,
              auto = true,
            },
            click = "v:lua.ScSa",
          },
          -- { text = { " " } },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { text = { " " } },
          {
            sign = {
              namespace = { "gitsign" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              fillchar = " ",
              fillcharhl = "StatusColumnSeparator",
            },
            click = "v:lua.ScSa",
          },
        },
        ft_ignore = {
          "help",
          "vim",
          "fugitive",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "noice",
          "lazy",
          "toggleterm",
        },
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gv",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Show file history",
      },
      {
        "<leader>gV",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Show branch history",
      },
    },
    opts = {},
  },

  {
    "nvim-tree/nvim-web-devicons",
    event = { "VeryLazy" },
    opts = {
      override = {
        ["ipynb"] = {
          icon = "",
          color = "#519aba",
          cterm_color = "231",
          name = "ReStructuredText",
        },
        ["rst"] = {
          icon = "",
          color = "#519aba",
          cterm_color = "231",
          name = "ReStructuredText",
        },
        ["pyx"] = {
          icon = "",
          color = "#C78851",
          cterm_color = "136",
          name = "PYX",
        },
        ["pxd"] = {
          icon = "",
          color = "#52778B",
          cterm_color = "110",
          name = "PXD",
        },
      },
    },
  },
  "MunifTanjim/nui.nvim",

  {
    "famiu/bufdelete.nvim", -- For with confirm+less noice
    keys = {
      {
        "<leader>q",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Delete current Buffer",
      },
    },
  },

  {
    "echasnovski/mini.files",
    keys = {
      {
        "-",
        function()
          local minifiles = require("mini.files")
          if vim.bo.ft == "minifiles" then
            minifiles.close()
          else
            local file = vim.api.nvim_buf_get_name(0)
            local file_exists = vim.fn.filereadable(file) ~= 0
            minifiles.open(file_exists and file or nil)
            minifiles.reveal_cwd()
          end
        end,
        desc = "Focus explorer",
      },
      {
        "_",
        function()
          require("mini.files").close()
        end,
        desc = "Toggle explorer",
      },
    },
    opts = {
      content = {
        filter = require("helpers.files").filter_show_default,
        sort = require("helpers.files").sort_filter_gitignore,
      },
    },
    version = false,
    config = function(_, opts)
      require("mini.files").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local signs = require("config.icons").git.signs
      return {
        signs = {
          add = { text = signs.add },
          change = { text = signs.change },
          delete = { text = signs.delete },
          topdelete = { text = signs.topdelete },
          changedelete = { text = signs.changedelete },
          untracked = { text = signs.untracked },
        },
        preview_config = {
          border = require("config.icons").borders.outer.all,
          style = "minimal",
          relative = "cursor",
          width = 88,
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "]g", function()
            if vim.wo.diff then
              return "]g"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[g", function()
            if vim.wo.diff then
              return "[g"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>gs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })
          map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Unstage hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>ub", gs.toggle_current_line_blame, { desc = "Toggle Git blame" })
          map("n", "<leader>gd", gs.diffthis, { desc = "Diff" })
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { desc = "Diff HEAD" })
          map("n", "<leader>gR", gs.toggle_deleted, { desc = "Toggle removed" })

          -- Text object
          map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      }
    end,
  },
  {
    "folke/which-key.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = {
      plugins = {},
      key_labels = { ["<leader>"] = "SPC" },
      icons = {
        separator = require("config.icons").indent.marker, -- symbol used between a key and it's label
      },
      window = {
        border = "none",
        position = "bottom",
        margin = { 1, 0, 1, 0.5 },
        padding = { 0, 0, 0, 0 },
        winblend = 0,
        zindex = 1000,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "Go to" },
        ["]"] = { name = "Next" },
        ["["] = { name = "Previous" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>t"] = { name = "Test" },
        ["<leader>T"] = { name = "Tabs" },
        ["<leader>r"] = { name = "Run" },
        ["<leader>u"] = { name = "Toggle" },
        ["<leader>D"] = { name = "Debug" },
        ["<leader>S"] = { name = "Search" },
        ["<leader>a"] = { name = "Activate" },
        ["<leader>m"] = { name = "Make" },
        ["\\"] = { name = "Local leader" },
      })
      -- require("which-key.plugins").plugins["marks2"] = require("helpers.which_key").marks2
      -- require("which-key.plugins")._setup(require("helpers.which_key").marks2, {})
      -- require("which-key.plugins").plugins["registers2"] = require("helpers.which_key").registers2
      -- require("which-key.plugins")._setup(require("helpers.which_key").registers2, {})
    end,
  },
  {
    "echasnovski/mini.clue",
    enabled = false,
    version = false,
    event = "VeryLazy",
    config = function(_, _)
      local miniclue = require("mini.clue")
      miniclue.setup({
        window = { delay = 500 },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          { mode = "n", keys = "\\" },
          { mode = "x", keys = "\\" },

          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function(_, opts)
      local alpha = require("alpha")
      local default = require("alpha.themes.startify")
      default.nvim_web_devicons.enabled = false
      alpha.setup(default.config)
    end,
  },
  {
    "echasnovski/mini.pick",
    version = "*",
    dependencies = { "echasnovski/mini.extra" },
    keys = function()
      local MiniPick = require("mini.pick")
      local MiniExtra = require("mini.extra")

      return {
        {
          "<leader>f",
          function()
            MiniPick.builtin.files({})
          end,
          desc = "Find files",
        },
        {
          "<leader><space>",
          function()
            MiniPick.builtin.buffers({ include_current = false })
          end,
          desc = "Search buffers",
        },
        {
          "<leader>r",
          function()
            MiniExtra.pickers.oldfiles()
          end,
          desc = "Recent files",
        },
        {
          "<leader>s",
          function()
            MiniPick.builtin.grep_live({ tool = "rg" })
          end,
          desc = "Search",
        },
        {
          "<leader>S",
          function()
            MiniExtra.pickers.buf_lines({ scope = "current" })
          end,
          desc = "Search in buffer",
        },
        {
          "<leader>'",
          "<cmd>Pick resume<cr>",
          desc = "Resume last search",
        },
        {
          "<leader>p",
          function()
            MiniExtra.pickers.lsp({
              scope = "workspace_symbol",
            })
          end,
          desc = "Search symbols",
        },
      }
    end,
    opts = {
      mappings = {
        choose_marked = "<C-q>",
        move_down = "<C-j>",
        move_start = "<C-g>",
        move_up = "<C-k>",
      },
      window = {
        prompt_cursor = "▏",
        prompt_prefix = "  ",
        config = { border = "none" },
      },
      options = {
        content_from_bottom = false,
      },
    },
    config = function(_, opts)
      require("mini.pick").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = require("config.icons").statuscol, highlight = "IndentBlanklineChar" },
      scope = { enabled = false },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      -- local hooks = require("ibl.hooks")
      -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },
}
