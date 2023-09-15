return {
  -- {
  --   "folke/trouble.nvim",
  --   cmd = "Trouble",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   opts = {
  --     win_config = { border = require("config.icons").borders.outer.all },
  --     auto_preview = false,
  --     group = false, -- group results by file
  --     padding = false,
  --     mode = "document_diagnostics",
  --     use_diagnostic_signs = false,
  --   },
  -- },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>l",
        function()
          require("edgy").toggle("right")
        end,
        desc = "Toggle status",
      },
      {
        "<leader>j",
        function()
          require("edgy").toggle("bottom")
        end,
        desc = "Toggle panel",
      },
    },
    opts = {
      animate = {
        enabled = false,
      },
      icons = { open = "", closed = "" },
      wo = { winbar = false },
      bottom = {
        { ft = "qf", title = "Quickfix", size = { height = 0.3 }, pinned = true, open = "copen" }, -- for some reason this has to go first
        -- {
        --   ft = "Trouble",
        --   title = "Diagnostics",
        --   size = { height = 0.3 },
        --   pinned = true,
        --   open = "Trouble document_diagnostics",
        -- },
        { ft = "fugitive", title = "Git status", size = { height = 0.3 } },
        { ft = "dap-repl", title = "Debug console", size = { height = 0.3 } },
        { ft = "neotest-output-panel", title = "Test output", size = { height = 0.3 } },
        {
          ft = "help",
          title = "Help",
          size = { height = 20 },
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      },
      right = {
        { ft = "dapui_scopes", "Debug scopes", size = { width = 0.3 } },
        {
          title = "Test summary",
          ft = "neotest-summary",
          size = { height = 0.5, width = 0.3 },
          open = function()
            require("neotest").summary.open()
          end,
          pinned = true,
        },
        {
          title = "Build tasks",
          ft = "OverseerList",
          size = { height = 0.5, width = 0.3 },
          open = "OverseerOpen right",
          pinned = true,
        },
      },
      left = {
        {
          title = "Explorer",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5, width = 40 },
          pinned = true,
          open = "Neotree focus",
        },
        {
          title = "Symbols",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "document_symbols"
          end,
          size = { height = 0.5, width = 40 },
          -- pinned = true,
          -- open = "Neotree position=right document_symbols",
        },
        { ft = "neo-tree", size = { height = 0.5, width = 40 } },
      },
    },
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
        space = "",
      }
      require("tabby.tabline").set(function(line)
        return {
          -- {
          --   { "  ", hl = theme.head },
          --   line.sep(icons.right .. " ", theme.head, theme.fill),
          -- },
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
    opts = {
      override = {
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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("helpers.toggle").focus_neotree("filesystem")
        end,
        desc = "Focus explorer",
      },
      -- {
      --   "<leader>Es",
      --   function()
      --     require("helpers.toggle").focus_neotree("document_symbols")
      --   end,
      --   desc = "Focus symbols",
      -- },
      {
        "<leader>gh",
        function()
          require("helpers.toggle").focus_neotree("git_status")
        end,
        desc = "Focus Git status",
      },
      {
        "<leader>b",
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
        close_if_last_window = true,
        -- popup_border_style = icons.borders.outer.all,
        use_popups_for_input = false,
        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
        filesystem = {
          follow_current_file = { enabled = true },
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
          -- winbar = true,
          -- statusline = true, -- toggle to show selector on statusline
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
    "nvim-lualine/lualine.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons")
      return {
        options = {
          theme = "auto",
          -- globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
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
            -- {
            --   function()
            --     return require("config.icons").debug.debug .. require("dap").status()
            --   end,
            --   cond = function()
            --     return package.loaded["dap"] and require("dap").status() ~= ""
            --   end,
            -- },
            {
              function()
                return require("config.icons").debug.debug .. " " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              -- color = "DiagnosticSignWarn",
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
                return require("helpers.toggle").format_active()
              end,
            },
            {
              function()
                return ""
              end,
              cond = function()
                return require("helpers.toggle").conceal_active()
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
        ["\\"] = { name = "Mark" },
      })
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
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

              -- Replace the title of Neotree popups
              if string.match(conf.title, "^Enter new name for") then
                conf.title = "New name"
                -- conf.border = "rounded"
              elseif string.match(conf.title, "Are you sure you want to delete") then
                conf.title = "Delete (y/n)"
              elseif string.match(conf.title, "^Enter name for new file or directory") then
                conf.title = "New file or directory"
              elseif string.match(conf.title, "^Enter name for new directory") then
                conf.title = "New directory"
              end
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
    opts = {
      char = "", --require("config.icons").indent.dotted_marker,
      indent_blankline_context_char = require("config.icons").indent.marker,
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = true,
    },
  },
}
