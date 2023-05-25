return {

  {
    "rcarriga/nvim-dap-ui",
    -- event = { "BufReadPre", "BufNewFile" },
    keys = function()
      return {
        {
          "<F9>",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle breakpoint",
        },
        {
          "<F21>", -- SHIFT+F9
          function()
            local Input = require("nui.input")
            local event = require("nui.utils.autocmd").event
            local popup_options = {
              relative = "cursor",
              position = {
                row = -2,
                col = 1,
              },
              size = 50,
              border = {
                style = require("config.icons").borders.empty,
                text = {
                  top = "Condition",
                  title_pos = "center",
                },
              },
              win_options = {
                winhighlight = "PopupNormal:FloatBorder",
              },
            }

            local input = Input(popup_options, {
              on_submit = function(value)
                require("dap").set_breakpoint(value)
              end,
            })
            input:map("n", "<Esc>", function()
              input:unmount()
            end, { noremap = true })
            input:on(event.BufLeave, function()
              input:unmount()
            end)
            input:mount()
          end,
          desc = "Set conditional breakpoint",
        },
        {
          "<F29>", -- CTRL+F5
          function()
            require("dap").run_last()
          end,
          desc = "Run last debug",
        },
        {
          "<F17>", -- SHIFT+F5
          function()
            require("dap").stop()
          end,
          desc = "Stop debugging",
        },
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
          desc = "Continue debugging",
        },
        {
          "<F10>",
          function()
            require("dap").step_over()
          end,
          desc = "Step over",
        },
        {
          "<F11>",
          function()
            require("dap").step_into()
          end,
          desc = "Step into",
        },
        {
          "<F23>", --SHIFT+F11
          function()
            require("dap").step_out()
          end,
          desc = "Step out",
        },
      }
    end,
    dependencies = {
      {
        -- "MunifTanjim/nui.nvim",
        "mfussenegger/nvim-dap",
        dependencies = {
          { "jayp0521/mason-nvim-dap.nvim" },
        },
        opts = function()
          return {
            adapters = {
              python = {
                type = "executable",
                command = "debugpy-adapter",
                args = {},
              },
            },
            configurations = {
              python = {
                {
                  type = "python",
                  request = "launch",
                  name = "Launch file",

                  program = "${file}",
                  pythonPath = require("helpers.python").executable,
                },
              },
            },
          }
        end,
        config = function(_, opts)
          local dap = require("dap")
          for key, options in pairs(opts) do
            for language, language_config in pairs(options) do
              dap[key][language] = language_config
            end
          end
        end,
      },
    },
    opts = function()
      local icons = require("config.icons")
      return {
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = icons.debug.disconnect,
            pause = icons.debug.pause,
            play = icons.debug.play,
            run_last = icons.debug.run_last,
            step_back = icons.debug.step_back,
            step_into = icons.debug.step_into,
            step_out = icons.debug.step_out,
            step_over = icons.debug.step_over,
            terminate = icons.debug.terminate,
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = icons.borders.outer.all,
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = icons.folder.collapsed,
          current_frame = icons.folder.collapsed,
          expanded = icons.folder.expanded,
        },
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.60,
              },
              {
                id = "stacks",
                size = 0.30,
              },
              {
                id = "breakpoints",
                size = 0.20,
              },
            },
            position = "left",
            size = 50,
          },
          {
            elements = {
              {
                id = "repl",
                size = 1.0,
              },
              -- {
              --   id = "console",
              --   size = 0.5,
              -- },
            },
            position = "bottom",
            size = 20,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      }
    end,
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      local neotree_open = require("helpers.toggle").is_neotree_open()

      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        if neotree_open then
          vim.cmd.Neotree("close")
        end
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
        if neotree_open then
          vim.cmd.Neotree("show")
        end
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        if neotree_open then
          vim.cmd.Neotree("show")
        end
      end
    end,
  },

  {
    "jayp0521/mason-nvim-dap.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:mason-org/mason-registry",
          },
        },
      },
    },
    opts = {
      ensure_installed = { "debugpy" },
    },
  },
}
