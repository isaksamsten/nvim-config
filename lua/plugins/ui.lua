return {
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      progress = {
        poll_rate = 0,
        suppress_on_insert = true,
        ignore_done_already = true,
        ignore_empty_message = true,
        display = {
          render_limit = 3,
        },
      },
      notification = {
        override_vim_notify = false,
      },
    },
  },
  {
    "romainl/vim-qf",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:qf_mapping_ack_style = 1
        let g:qf_auto_open_quickfix = 0
        nmap <C-S-q> <Plug>qf_qf_toggle
        nmap <C-q> <Plug>qf_qf_switch
      ]])
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "VeryLazy" },
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
              namespace = { "sia_diff+" },
              maxwidth = 1,
              colwidth = 1,
              auto = true,
            },
          },
          {
            sign = {
              namespace = { "gitsigns+" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              fillchar = require("config.icons").statuscol,
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
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  { "MunifTanjim/nui.nvim", lazy = true },

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
    version = false,
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
        signs_staged = {
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
          local gs = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "]g", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.nav_hunk("next")
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[g", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.nav_hunk("prev")
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
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keys",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Persist",
      },
      {
        "<leader>d<space>",
        function()
          require("which-key").show({ keys = "<leader>d", loop = true })
        end,
        desc = "Persist",
      },
    },
    opts = {
      plugins = {},
      preset = "helix",
      icons = {
        -- mappings = false,
        separator = require("config.icons").indent.marker, -- symbol used between a key and it's label
      },
      win = {
        border = "none",
        wo = {
          winblend = 0,
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        {
          mode = { "n", "v" },
          { "<leader>d", group = "Debug" },
          { "<leader>S", group = "Search alternate" },
          { "<leader>T", group = "Tabs" },
          { "<leader>g", group = "Git" },
          { "<leader>a", group = "AI" },
          {
            "<leader>b",
            group = "Buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          { "<leader>t", group = "Test" },
          { "<leader>u", group = "Toggle" },
          { "[", group = "Previous" },
          { "\\", group = "Backslash" },
          { "]", group = "Next" },
          { "g", group = "Go to" },
          { "gz", group = "AI", icon = "󱙺" },
        },
      })
    end,
  },

  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VimEnter",
    opts = function()
      local starter = require("mini.starter")
      return {
        evaluate_single = true,
        items = {
          starter.sections.recent_files(9, true),
        },
        content_hooks = {
          -- starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing("all"),
          starter.gen_hook.aligning("center", "top"),
          starter.gen_hook.padding(0, 10),
        },
        query_updaters = "123456789",
        silent = true,
        footer = "",
      }
    end,
    config = function(_, opts)
      require("mini.starter").setup(opts)
    end,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
    event = "VimEnter",
    config = function(_, opts)
      local alpha = require("alpha")
      local default = require("alpha.themes.startify")
      -- default.nvim_web_devicons.enabled = false
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
            require("helpers").pick_buffers()
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
        move_start = "<C-g>",
      },
      window = {
        prompt_caret = "▏",
        prompt_prefix = "  ",
        config = { border = "none" },
      },
      options = {
        content_from_bottom = false,
      },
    },
    config = function(_, opts)
      require("mini.pick").setup(opts)
      -- vim.ui.select = require("mini.pick").ui_select
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      scope = { enabled = false },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
}
