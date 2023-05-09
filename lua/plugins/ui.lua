return {
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
      keys = {
        {
          "<leader>un",
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
              auto = false,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            sign = {
              name = { "GitSigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
              fillchar = require("config.icons").indent.marker,
              fillcharhl = "StatusColumnSeparator",
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
        "<leader>hv",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Show file history",
      },
      {
        "<leader>hV",
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
        "<leader>q",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Delete current Buffer",
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree focus<CR>", desc = "Focus explorer" },
      { "<leader>b", "<cmd>Neotree show toggle<CR>", desc = "Toggle explorer" },
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
        close_if_last_window = true,
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "open_current",
        },
        source_selector = {
          winbar = true,
          statusline = false, -- toggle to show selector on statusline
          content_layout = "center",
          tabs_layout = "equal",
          sources = {
            { source = "filesystem", display_name = "" },
            { source = "buffers", display_name = "" },
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
      }
    end,
  },

  {
    "windwp/windline.nvim",
    event = "VeryLazy",
    enabled = true,
    version = false,
    config = function()
      -- require("wlsample.evil_line")
      -- require("wlsample.vscode")
      require("helpers.statusline")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons")
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          -- disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = { left = "", right = "" },
          section_separators = { right = "", left = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                return string.sub(mode, 0, 6)
              end,
            },
          },
          lualine_b = {
            { "branch", icon = icons.git.branch, separator = "" },
            {
              "diff",
              symbols = {
                added = icons.git.add .. " ",
                modified = icons.git.change .. " ",
                removed = icons.git.delete .. " ",
              },
            },
          },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            {
              "filename",
              path = 1,
              shorting_target = 40,
              fmt = function(filename)
                -- Small attempt to workaround https://github.com/nvim-lualine/lualine.nvim/issues/872
                if #filename > 80 then
                  filename = vim.fs.basename(filename)
                end

                if #filename > 80 then
                  return string.sub(filename, #filename - 80, #filename)
                end
                return filename
              end,
              symbols = {
                modified = " " .. icons.file.modified .. " ",
                readonly = " " .. icons.file.readonly .. " ",
                unnamed = "",
                newfile = " " .. icons.file.new .. " ",
              },
            },
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = {
            {
              function()
                return require("config.icons").debug.debug .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = "DiagnosticSignWarn",
            },
          },
          lualine_y = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.error,
                warn = icons.diagnostics.warn,
                info = icons.diagnostics.info,
                hint = icons.diagnostics.hint,
              },
              cond = function()
                return require("helpers.toggle").is_diagnostics_active
              end,
            },
            -- {
            --   function()
            --     local python = require("helpers.python").python()
            --     if python then
            --       return string.format("%s [%s]", python.name, python.version)
            --     else
            --       return "[No interpreter]"
            --     end
            --   end,
            --   cond = function()
            --     return vim.bo.ft == "python"
            --   end,
            -- },
          },
          lualine_z = {
            {
              function()
                return ""
              end,
              cond = function()
                return vim.b.format_on_save ~= false and require("helpers.format").format_on_save
              end,
            },
            {
              function()
                return ""
              end,
              cond = function()
                return require("helpers.toggle").is_conceal_active
              end,
            },
            {
              function()
                return require("config.icons").ui.remote
              end,
              cond = require("helpers").is_remote,
            },
          },
        },
        extensions = { "nvim-tree" },
      }
    end,
    config = function(_, opts)
      local lualine = require("lualine")
      lualine.setup(opts)
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

          map("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Unstage hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "Preview hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "Toggle Git blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "Diff HEAD" })
          map("n", "<leader>hR", gs.toggle_deleted, { desc = "Toggle removed" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
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
        ["<leader>h"] = { name = "Git" },
        ["<leader>d"] = { name = "Debug" },
        ["<leader>t"] = { name = "Test" },
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
        {
          "<leader>o",
          function()
            require("telescope").extensions.file_browser.file_browser(ivy({}))
          end,
          desc = "Open file",
        },
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
          "<leader>D",
          function()
            require("telescope.builtin").diagnostics(vertical({ prompt_title = "Diagnostics", preview_title = "" }))
          end,
          desc = "Search diagnostics",
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
          desc = "Search symbols",
        },
        -- {
        --   "<leader>T",
        --   function()
        --     require("telescope.builtin").lsp_workspace_symbols(vertical({
        --       prompt_title = "Symbols",
        --       preview_title = "Preview",
        --       symbols = {
        --         "Class",
        --         "Function",
        --         "Method",
        --         "Interface",
        --         "Module",
        --         "Struct",
        --         "Trait",
        --         "Property",
        --       },
        --     }))
        --   end,
        --   desc = "Find symbol in workspace",
        -- },
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
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      require("telescope").load_extension("file_browser")
      telescope.setup(opts)
    end,
  },

  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    opts = {
      preview = {
        show_title = false,
        border_chars = { "▏", "▕", "▔", "▁", "🭽", "🭾", "🭼", "🭿", "" },
      },
    },
  },

  -- active indent guide and indent text objects
  -- {
  --   "echasnovski/mini.indentscope",
  --   event = "BufReadPre",
  --   version = false, -- wait till new 0.7.0 release to put it back on semver
  --   opts = {
  --     symbol = "│",
  --   },
  --   config = function(_, opts)
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
  --       callback = function()
  --         vim.b.miniindentscope_disable = true
  --       end,
  --     })
  --     require("mini.indentscope").setup(
  --       vim.tbl_extend("keep", opts, { draw = { animation = require("mini.indentscope").gen_animation.none() } })
  --     )
  --   end,
  -- },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      char = require("config.icons").indent.dotted_marker,
      indent_blankline_context_char = require("config.icons").indent.marker,
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = true,
    },
  },
}
