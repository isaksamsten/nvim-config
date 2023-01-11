local function close_command(bufnr)
  require("bufdelete").bufdelete(bufnr, true)
end

return {
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "NeoTree" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
      },
      source_selector = {
        winbar = true,
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "✖",
          renamed = "",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "BufAdd",
    dependencies = {
      { "famiu/bufdelete.nvim" },
    },
    opts = {
      options = {
        close_command = close_command,
        right_mouse_command = close_command,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      local bufferline = require("bufferline")
      bufferline.setup(opts)

      vim.keymap.set("n", "<leader>bb", "<cmd>:e #<cr>", { desc = "Switch to Other Buffer" })
      vim.keymap.set("n", "<leader>bd", close_command, { desc = "Delete current Buffer" })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = require("config.icons").diagnostics,
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          "diff",
        },
        lualine_y = {
          { "progress", separator = "", padding = { left = 1, right = 0 } },
        },
      },
      extensions = { "nvim-tree" },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  {
    "windwp/nvim-spectre",
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer " })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk " })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "Blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Show diff" })
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "Show diff (last commit)" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
      end,
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>h"] = { name = "+git" },
        ["<leader>s"] = { name = "+search" },
      })
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function(_, opts)
      local alpha = require("alpha")
      local default = require("alpha.themes.startify")
      alpha.setup(default.config)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.*",
    lazy = false,
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Find existing buffers" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fh", builtin.oldfiles, { desc = "Recently opened files" })

      vim.keymap.set("n", "<leader>sb", builtin.grep_string, { desc = "Search buffer" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
    end,
  },
}
