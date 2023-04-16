return {

  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons").ui
      return {
        cmdline = {
          enabled = true, -- enables the Noice cmdline UI
          view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
          opts = {}, -- global options for the cmdline. See section on views
          format = {
            cmdline = { pattern = "^:", icon = icons.cmd, lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = icons.search_down, lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = icons.search_up, lang = "regex" },
            filter = { pattern = "^:%s*!", icon = icons.filter, lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = icons.help },
            git = { pattern = { "^:%s*G?i?t?%s+" }, icon = icons.git },
            input = {}, -- Used by input()
          },
        },
        messages = {
          enabled = true, -- enables the Noice messages UI
          view = "mini", -- default view for messages
          view_error = "mini", -- view for errors
          view_warn = "mini", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        popupmenu = {
          enabled = false, -- enables the Noice popupmenu UI
          backend = "cmp", -- backend to use to show regular cmdline completions
          kind_icons = {}, -- set to `false` to disable icons
        },
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
                { event = "mini" },
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
                { event = "mini" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
            filter_opts = { count = 1 },
          },
          errors = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
        },
        notify = {
          enabled = true,
          view = "mini",
        },
        lsp = {
          progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = "mini",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            view = nil, -- when nil, use defaults from documentation
            opts = {
              size = {
                width = "auto",
                height = "auto",
                max_height = 20,
                max_width = 70,
              },
            }, -- merged with defaults from documentation
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
              luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
              throttle = 50, -- Debounce lsp signature help request by 50ms
            },
            view = nil, -- when nil, use defaults from documentation
            opts = {}, -- merged with defaults from documentation
          },
          message = {
            enabled = true,
            view = "mini",
            opts = {},
          },
          documentation = {
            view = "hover",
            opts = {
              lang = "markdown",
              replace = true,
              render = "plain",
              format = { "{message}" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
        },
        markdown = {
          hover = {
            ["|(%S-)|"] = vim.cmd.help, -- vim help links
            ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
          },
          highlights = {
            ["|%S-|"] = "@text.reference",
            ["@%S+"] = "@parameter",
            ["^%s(Parameters:)"] = "@text.title",
            ["^%s(Return:)"] = "@text.title",
            ["^%s(See also:)"] = "@text.title",
            ["{%S-}"] = "@parameter",
          },
        },
        health = {
          checker = true, -- Disable if you don't want health checks to run
        },
        smart_move = {
          enabled = true, -- you can disable this behaviour here
          excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = false, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
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
            },
            click = "v:lua.ScSa",
          },
        },
        ft_ignore = { "help", "vim", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "toggleterm" },
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

  {
    "ahmedkhalf/project.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      ignore_lsp = { "null-ls" },
    },
    keys = {
      {
        "<leader>p",
        function()
          require("telescope").extensions.projects.projects({})
        end,
        desc = "Recent projects",
      },
    },
    config = function(opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
  },

  "nvim-tree/nvim-web-devicons",

  "MunifTanjim/nui.nvim",
  {
    "famiu/bufdelete.nvim",
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

  -- {
  --   "j-hui/fidget.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {
  --     text = {
  --       spinner = "pipe", -- animation shown when tasks are ongoing
  --       done = "✔", -- character shown when all tasks are complete
  --       commenced = "", -- message shown when task starts
  --       completed = "", -- message shown when task completes
  --     },
  --     sources = {
  --       ltex = { ignore = true },
  --       ["null-ls"] = { ignore = true },
  --     },
  --   },
  -- },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree <CR>", desc = "Focus explorer" },
      { "<leader>b", "<cmd>Neotree toggle<CR>", desc = "Toggle explorer" },
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
          tab_labels = {
            filesystem = "",
            buffers = "",
            git_status = "",
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
    "nvim-lualine/lualine.nvim",
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
            -- {
            --   "macro-recording",
            --   fmt = function()
            --     local recording_register = vim.fn.reg_recording()
            --     if recording_register == "" then
            --       return ""
            --     else
            --       return " " .. recording_register
            --     end
            --   end,
            -- },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            {
              "filename",
              path = 1,
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
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              -- color = fg("Statement"),
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              -- color = fg("Constant"),
            },
            {
              "format-on-save",
              fmt = function()
                if vim.b.format_on_save ~= false and require("helpers.format").format_on_save then
                  return ""
                else
                  return ""
                end
              end,
            },
            {
              "conceal-active",
              fmt = function()
                if require("helpers.toggle").is_conceal_active then
                  return ""
                else
                  return ""
                end
              end,
            },
            {
              function()
                return "SSH"
              end,
              cond = require("helpers").is_remote,
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
            {
              function()
                local python = require("helpers.python").python()
                if python then
                  return string.format("%s [%s]", python.name, python.version)
                else
                  return "[No interpreter]"
                end
              end,
              cond = function()
                return vim.bo.ft == "python"
              end,
              color = function()
                local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(
                  vim.api.nvim_buf_get_option(0, "filetype")
                )
                return { fg = color }
              end,
            },
          },
          lualine_z = {
            { "location" },
          },
        },
        extensions = { "nvim-tree" },
      }
    end,
    config = function(_, opts)
      local lualine = require("lualine")
      lualine.setup(opts)
      -- vim.api.nvim_create_autocmd("RecordingEnter", {
      --   callback = function()
      --     lualine.refresh({
      --       place = { "statusline" },
      --     })
      --   end,
      -- })
      -- vim.api.nvim_create_autocmd("RecordingLeave", {
      --   callback = function()
      --     local timer = vim.loop.new_timer()
      --     timer:start(
      --       50,
      --       0,
      --       vim.schedule_wrap(function()
      --         lualine.refresh({
      --           place = { "statusline" },
      --         })
      --       end)
      --     )
      --   end,
      -- })
    end,
  },

  {
    "windwp/nvim-spectre",
    keys = {
      {
        "<leader>R",
        function()
          require("spectre").open()
        end,
        desc = "Search and replace",
      },
    },
    opts = {
      open_cmd = "60vnew",
      line_sep_start = "┌─────────────────────────────────────────────────────────────",
      result_padding = "│ ",
      line_sep = "└─────────────────────────────────────────────────────────────",
    },
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
          border = "rounded",
          style = "minimal",
          relative = "cursor",
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
          map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
          map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer " })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk " })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Show diff" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "Show diff (last commit)" })
          map("n", "<leader>hd", gs.toggle_deleted, { desc = "Toggle deleted" })

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
          "<leader>f",
          function()
            require("telescope.builtin").find_files(ivy({}))
          end,
          desc = "Open files",
        },

        {
          "<leader>s",
          function()
            require("telescope").extensions.live_grep_args.live_grep_args(
              vertical({ prompt_title = "Search", preview_title = "" })
            )
          end,
          desc = "Search files",
        },
        -- {
        --   "<leader>,",
        --   function()
        --     require("telescope.builtin").diagnostics(vertical({ prompt_title = "Diagnostics", preview_title = "" }))
        --   end,
        --   desc = "Search diagnostics",
        -- },
        {
          "<leader>o",
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
        selection_caret = "   ",
        multi_icon = "   ",
        prompt_prefix = "   ",
        entry_prefix = "    ",
      },
    },
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

  { "kevinhwang91/nvim-bqf", event = "VeryLazy", config = true },

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
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = true,
    },
  },
}
