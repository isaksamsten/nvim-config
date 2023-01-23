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
      { "<leader>e", "<cmd>Neotree <CR>", desc = "Toggle explorer" },
      { "<leader>b", "<cmd>Neotree buffers right<CR>", desc = "Toggle buffers" },
      { "<leader>H", "<cmd>Neotree float git_status<CR>", desc = "Toggle source control" },
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
      window = {
        mappings = {
          ["<space>"] = "none",
          ["<tab>"] = "toggle_node",
        },
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
    keys = {
      { "]b", "<cmd>BufferLineCycleNext<CR>" },
      { "[b", "<cmd>BufferLineCyclePrev<CR>" },
    },
    opts = {
      options = {
        close_command = close_command,
        right_mouse_command = close_command,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        -- highlights = require("catppuccin.groups.integrations.bufferline").get(),
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

      vim.keymap.set("n", "<leader>q", close_command, { desc = "Delete current Buffer" })
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
    "windwp/nvim-spectre",
    keys = {
      {
        "<leader>R",
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
        ["g"] = { name = "Go to" },
        ["]"] = { name = "Next" },
        ["["] = { name = "Previous" },
        ["<leader>h"] = { name = "Git" },
        ["<leader>d"] = { name = "Debug" },
        ["<leader>t"] = { name = "Toggle" },
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
    keys = function(_, keys)
      local function vertical(config)
        return require("telescope.themes").get_dropdown(config)
      end
      local function ivy()
        return require("telescope.themes").get_ivy({ previewer = false })
      end
      return {
        {
          "<leader><space>",
          function()
            require("telescope.builtin").buffers(
              vertical({ prompt_title = "Buffers", previewer = false, sort_mru = true, ignore_current_buffer = true })
            )
          end,
          desc = "List buffers",
        },
        {
          "<leader>p",
          function()
            require("telescope.builtin").find_files(ivy())
          end,
          desc = "Open file",
        },
        {
          "<leader>P",
          function()
            require("telescope.builtin").commands(ivy())
          end,
          desc = "Commands",
        },

        {
          "<leader>S",
          function()
            require("telescope.builtin").live_grep(vertical({ prompt_title = "Search", preview_title = "" }))
          end,
          desc = "Search",
        },
        {
          "<leader>i",
          function()
            require("telescope.builtin").diagnostics(vertical({ prompt_title = "Diagnostics", preview_title = "" }))
          end,
          desc = "List diagnostics",
        },
        {
          "<leader>O",
          function()
            require("telescope.builtin").lsp_document_symbols(vertical({
              prompt_title = "Symbols",
              preview_title = "",
              symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
              },
            }))
          end,
          desc = "Find symbol in buffer",
        },
        {
          "<leader>T",
          function()
            require("telescope.builtin").lsp_workspace_symbols(vertical({
              prompt_title = "Symbols",
              preview_title = "",
              symbols = {
                "Class",
                "Function",
                "Method",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Property",
              },
            }))
          end,
          desc = "Find symbol in workspace",
        },
      }
    end,
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
    end,
  },

  { "kevinhwang91/nvim-bqf", event = "BufReadPre", config = true },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "BufReadPre",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
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
}
