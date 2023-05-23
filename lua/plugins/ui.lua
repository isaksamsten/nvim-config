return {
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
      keys = {
        {
          "<M-n>",
          function()
            require("notify").dismiss({ silent = true, pending = true })
          end,
          desc = "Dismiss notifications",
        },
      },
      opts = function()
        local helpers = require("helpers.nvim-notify")
        local icons = require("config.icons")
        return {
          icons = {
            DEBUG = icons.debug.debug,
            ERROR = icons.diagnostics.error,
            INFO = icons.diagnostics.info,
            WARN = icons.diagnostics.warn,
          },
          timeout = 2000,
          render = helpers.render,
          stages = "static",
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { border = require("config.icons").borders.outer.all })
          end,
          max_height = function()
            return math.floor(vim.o.lines * 0.25)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.25)
          end,
        }
      end,
    },
    opts = function()
      local icons = require("config.icons").ui
      local popup_opts = {
        border = { style = require("config.icons").borders.outer.all, text = { top = "" } },
      }
      return {
        views = {
          split = {
            enter = true,
          },
          confirm = {
            border = { style = require("config.icons").borders.outer.all, text = { top = "" } },
          },
        },
        cmdline = {
          enabled = true, -- enables the Noice cmdline UI
          -- view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
          opts = {}, -- global options for the cmdline. See section on views
          format = {
            cmdline = {
              pattern = "^:",
              icon = icons.cmd,
              lang = "vim",
              opts = popup_opts,
            },
            search_down = { kind = "search", pattern = "^/", icon = icons.search_down, lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = icons.search_up, lang = "regex" },
            filter = {
              pattern = "^:%s*!",
              icon = icons.filter,
              lang = "bash",
              opts = popup_opts,
            },
            lua = {
              pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
              icon = icons.lua,
              lang = "lua",
              opts = popup_opts,
            },
            git = {
              pattern = { "^:%s*G%s+" },
              icon = icons.git,
              opts = popup_opts,
            },
            help = {
              pattern = "^:%s*he?l?p?%s+",
              icon = icons.help,
              opts = popup_opts,
            },
            input = {}, -- Used by input()
          },
        },
        messages = {
          enabled = true, -- enables the Noice messages UI
          view = "notify", -- default view for messages
          view_error = "notify", -- view for errors
          view_warn = "notify", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        popupmenu = { enabled = true, backend = "nui" },
        redirect = {
          view = "popup",
          filter = { event = "msg_show" },
        },
        commands = {
          history = {
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
          },
          last = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
            filter_opts = { count = 1 },
          },
          errors = {
            view = "split",
            opts = { enter = true, format = "details" },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
        },
        notify = {
          enabled = true,
          view = "notify",
        },
        lsp = {
          progress = {
            enabled = false,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
          },
          hover = { enabled = false },
          signature = { enabled = false },
          message = { enabled = false },
          documentation = { enabled = false },
        },
        health = {
          checker = true, -- Disable if you don't want health checks to run
        },
        smart_move = { enabled = false },

        routes = {
          {
            filter = {
              event = "msg_show",
              find = "^E486",
            },
            view = "mini",
          },
          {
            filter = {
              event = "msg_show",
              find = "search hit BOTTOM, continuing at TOP",
            },
            view = "mini",
          },
          {
            filter = {
              event = "notify",
              kind = { "info" },
            },
            view = "mini",
          },
          {
            filter = {
              event = "msg_show",
              find = "%d+L, %d+B",
            },
            view = "mini",
          },
          {
            filter = {
              event = "msg_show",
              find = ";%s(%a+)%s#(%d+)", -- matches undo messages
            },
            view = "mini",
          },
          {
            filter = {
              event = "msg_show",
              find = "^%d+.*lines", -- fewer, more yanked etc lines
            },
            view = "mini",
          },
          {
            filter = {
              event = "msg_show",
              find = "^Already at", -- More undo messages
            },
            view = "mini",
          },
          {
            view = "cmdline_output",
            filter = { cmdline = "^:" },
          },
          {
            filter = {
              event = "msg_show",
              kind = "search_count",
            },
            opts = { skip = true },
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  {
    "nanozuki/tabby.nvim",
    event = "TabNew",
    opts = {
      theme = {
        fill = "TabLineFill",
        head = "TabLineHead",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLineSel",
      },
    },
    config = function(_, opts)
      local theme = opts.theme
      local icons = {
        left = "",
        right = "",
        space = " ",
      }
      require("tabby.tabline").set(function(line)
        return {
          {
            { "  ", hl = theme.head },
            line.sep(icons.right .. " ", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep(icons.space, hl, theme.fill),
              -- tab.number(),
              tab.name(),
              line.sep(icons.space, hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local hl = win.is_current() and theme.current_tab or theme.tab
            return {
              line.sep(icons.space, hl, theme.fill),
              win.buf_name(),
              line.sep(icons.space, hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          hl = theme.fill,
        }
      end)
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
              maxwidth = 1,
              colwidth = 2,
              auto = true,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { text = { " " } },
          {
            sign = {
              name = { "GitSigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              fillchar = require("config.icons").borders.outer.all[8],
              -- fillcharhl = "StatusColumnSeparator",
            },
            click = "v:lua.ScSa",
          },
        },
        ft_ignore = {
          "help",
          "vim",
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

  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  {
    "isaksamsten/bufdelete.nvim", -- For with confirm+less noice
    keys = {
      {
        "<C-q>",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Delete current Buffer",
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    cmd = "Neotree",
    keys = {
      {
        "<M-e>",
        function()
          require("helpers.toggle").focus_neotree("filesystem")
        end,
        desc = "Focus explorer",
      },
      {
        "<M-s>",
        function()
          require("helpers.toggle").focus_neotree("document_symbols")
        end,
        desc = "Focus symbols",
      },
      {
        "<M-g>",
        function()
          require("helpers.toggle").focus_neotree("git_status")
        end,
        desc = "Focus Git status",
      },
      {
        "<M-b>",
        function()
          require("helpers.toggle").neotree()
        end,
        desc = "Toggle explorer",
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    opts = function()
      local icons = require("config.icons")

      return {
        close_if_last_window = false,
        -- popup_border_style = icons.borders.outer.all,
        use_popups_for_input = false,
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
        },
        sources = {
          "filesystem",
          -- "buffers",
          "git_status",
          "document_symbols",
        },
        source_selector = {
          winbar = true,
          statusline = false, -- toggle to show selector on statusline
          content_layout = "center",
          tabs_layout = "equal",
          sources = {
            { source = "filesystem", display_name = "" },
            -- { source = "buffers", display_name = "" },
            { source = "git_status", display_name = "" },
            {
              source = "document_symbols",
              display_name = "",
              server_filter = {
                fn = function(name)
                  return name ~= "null-ls"
                end,
              },
            },
          },
        },
        window = {
          mappings = {
            ["<space>"] = "none",
            ["<tab>"] = "toggle_node",
          },
        },
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = icons.indent.marker,
            last_indent_marker = icons.indent.last,
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = icons.folder.collapsed,
            expander_expanded = icons.folder.expanded,
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = icons.folder.closed,
            folder_open = icons.folder.open,
            folder_empty = icons.folder.empty,
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = icons.file.modified,
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added = icons.git.add,
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = icons.git.delete, -- this can only be used in the git_status source
              renamed = icons.git.renamed, -- this can only be used in the git_status source
              -- Status type
              untracked = icons.git.untracked,
              ignored = icons.git.ignored,
              unstaged = icons.git.unstaged,
              staged = icons.git.staged,
              conflict = icons.git.conflict,
            },
          },
        },
        document_symbols = {
          kinds = {
            File = { icon = icons.kinds.File, hl = "Tag" },
            Namespace = { icon = icons.kinds.Namespace, hl = "Include" },
            Package = { icon = icons.kinds.Package, hl = "Label" },
            Class = { icon = icons.kinds.Class, hl = "Include" },
            Property = { icon = icons.kinds.Property, hl = "@property" },
            Enum = { icon = icons.kinds.Enum, hl = "@lsp.type.enum" },
            EnumMember = { icon = icons.kinds.Enum, hl = "@lsp.type.enumMember" },
            Event = { icon = icons.kinds.Enum, hl = "@number" },
            Function = { icon = icons.kinds.Function, hl = "Function" },
            String = { icon = icons.kinds.String, hl = "String" },
            Number = { icon = icons.kinds.Number, hl = "Number" },
            Array = { icon = icons.kinds.Array, hl = "Type" },
            Object = { icon = icons.kinds.Object, hl = "Type" },
            Key = { icon = icons.kinds.Key, hl = "" },
            Struct = { icon = icons.kinds.Struct, hl = "Type" },
            Operator = { icon = icons.kinds.Operator, hl = "Operator" },
            TypeParameter = { icon = icons.kinds.TypeParameter, hl = "Type" },
            StaticMethod = { icon = icons.kinds.StaticMethod, hl = "Function" },
            Constant = { icon = icons.kinds.Constant, hl = "Constant" },
          },
        },
      }
    end,
  },

  {
    "windwp/windline.nvim",
    event = "VeryLazy",
    enabled = true,
    version = false,
    config = function()
      require("helpers.statusline")
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
        ["gA"] = { name = "AI" },
        ["]"] = { name = "Next" },
        ["["] = { name = "Previous" },
        ["<leader>g"] = { name = "Git" },
        ["<M-r>"] = { name = "Run" },
        ["<M-a>"] = { name = "Activate" },
        ["<leader>o"] = { name = "Open" },
        ["<leader>u"] = { name = "Toggle" },
      })
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons")
      return {
        input = {
          border = icons.borders.empty,
          override = function(conf)
            conf.title_pos = "center"
            if conf.title then
              conf.title = string.gsub(conf.title, ":$", "")

              -- Replace the title of Neotree popups
              if string.match(conf.title, '^Enter new name for "%w+"') then
                conf.title = "New name"
              end
            end
          end,
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
                telescope = require("telescope.themes").get_cursor({}),
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
    version = "0.1.*",
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
          "<C-S-p>",
          function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols(vertical({
              prompt_title = "Symbols",
              preview_title = "Preview",
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
          desc = "Search symbols in workspace",
        },
      }
    end,
    opts = function()
      -- local icons = require("config.icons")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
          selection_caret = "   ",
          multi_icon = "   ",
          prompt_prefix = "   ",
          entry_prefix = "    ",
        },
      }
    end,
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      char = "", --require("config.icons").indent.dotted_marker,
      indent_blankline_context_char = require("config.icons").indent.marker,
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = true,
    },
  },
}
