return {
  {
    "romainl/vim-qf",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:qf_mapping_ack_style = 1
        nmap <C-Q> <Plug>qf_qf_toggle
        nmap <C-q> <Plug>qf_qf_switch

        nmap [q <Plug>qf_qf_previous
        nmap ]q  <Plug>qf_qf_next
      ]])
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VimEnter",
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
                "neotest", --[[ "Diagnostic" ]]
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
    event = "VimEnter",
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
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    branch = "master",
    enabled = false,
    opts = function()
      -- local function is_neotree(opts)
      --   return string.match(opts.prompt, '^Enter new name for "%w+"')
      --     or string.match(opts.prompt, "Are you sure you want to delete")
      --     or string.match(opts.prompt, "^Enter name for new")
      -- end
      local icons = require("config.icons")
      return {
        input = {
          padding = 1,
          border = icons.borders.outer.all,
          -- border = "shadow",
          override = function(conf)
            conf.title_pos = "center"
            if conf.title then
              conf.title = string.gsub(conf.title, ":$", "")
            end
          end,
          -- get_config = function(opts)
          --   if is_neotree(opts) then
          --     return {
          --       max_width = 60,
          --       min_width = 30,
          --     }
          --   end
          -- end,
        },
        select = {
          border = icons.borders.empty,
          override = function(conf)
            conf.title_pos = "center"
            if conf.title then
              conf.title = string.gsub(conf.title, ":$", "")
            end
          end,
          get_config = function(opts)
            if opts.kind == "codeaction" then
              return {
                backend = "telescope",
                telescope = require("helpers").telescope_theme("cursor", { prompt_title = "Code actions" }),
              }
            end
          end,
        },
      }
    end,
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
    version = false,
    keys = function(_, keys)
      local function vertical(config)
        return require("telescope.themes").get_dropdown(config)
      end
      local function ivy(config)
        config = config or {}
        return require("telescope.themes").get_ivy(vim.tbl_extend("keep", { previewer = false }, config))
      end
      return {
        {
          "<leader><space>",
          function()
            require("telescope.builtin").buffers(ivy({
              prompt_title = "Buffers",
              previewer = false,
              sort_mru = true,
              ignore_current_buffer = true,
            }))
          end,
          desc = "Search buffers",
        },
        -- {
        --   "<leader>o",
        --   function()
        --     require("telescope").extensions.file_browser.file_browser(ivy({}))
        --   end,
        --   desc = "Open file",
        -- },
        {
          "<leader>f",
          function()
            require("telescope.builtin").find_files(ivy({}))
          end,
          desc = "Find file",
        },

        {
          "<leader>s",
          function()
            require("telescope").extensions.live_grep_args.live_grep_args(
              vertical({ prompt_title = "Search", preview_title = "" })
            )
          end,
          desc = "Search",
        },
        {
          "<leader>Sw",
          function()
            require("telescope").extensions.live_grep_args.live_grep_args(
              vertical({ prompt_title = "Search", default_text = vim.fn.expand("<cword>"), preview_title = "" })
            )
          end,
          desc = "Search word under cursor",
        },

        {
          "<leader>Ss",
          function()
            require("telescope.builtin").current_buffer_fuzzy_find(
              vertical({ prompt_title = "Search buffer", preview_title = "" })
            )
          end,
          desc = "Search in buffer",
        },
        {
          "<leader>Sb",
          function()
            require("telescope.builtin").git_branches(vertical({ prompt_title = "Branches", preview_title = "" }))
          end,
          desc = "Search git branches",
        },
        {
          "<leader>'",
          "<cmd>Telescope resume<cr>",
          desc = "Resume last search",
        },

        {
          "<leader>d",
          function()
            require("telescope.builtin").diagnostics(vertical({ prompt_title = "Diagnostics", preview_title = "" }))
          end,
          desc = "Search diagnostics",
        },
        -- {
        --   "<leader>s",
        --   function()
        --     require("telescope.builtin").lsp_document_symbols(vertical({
        --       prompt_title = "Symbols",
        --       preview_title = "",
        --       symbols = {
        --         "Class",
        --         "Function",
        --         "Method",
        --         "Constructor",
        --         "Interface",
        --         "Module",
        --         "Struct",
        --         "Trait",
        --         "Field",
        --         "Property",
        --       },
        --     }))
        --   end,
        --   desc = "Search symbols",
        -- },
        {
          "<leader>p",
          function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols(vertical({
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
          desc = "Search symbols",
        },
      }
    end,
    opts = function()
      -- local icons = require("config.icons")
      local lga_actions = require("telescope-live-grep-args.actions")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
          selection_caret = "  ",
          multi_icon = "  ",
          prompt_prefix = "  ",
          entry_prefix = "   ",
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = function()
                  lga_actions.quote_prompt()
                end,
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      }
    end,
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
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
