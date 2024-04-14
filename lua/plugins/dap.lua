return {
  {
    "rcarriga/nvim-dap-ui",
    -- event = { "BufReadPre", "BufNewFile" },
    keys = function()
      return {
        {
          "<F4>",
          function()
            require("dapui").float_element("scopes", { enter = true })
          end,
          desc = "Open debug interface",
        },
        {
          "<leader>Ds",
          function()
            require("dapui").toggle({ layout = 1 })
          end,
          desc = "Open debug scopes.",
        },
        {
          "<leader>Dc",
          function()
            require("dapui").toggle({ layout = 2 })
          end,
          desc = "Open debug console.",
        },

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
            require("dap").close()
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
      "nvim-neotest/nvim-nio",
      {
        -- "MunifTanjim/nui.nvim",
        "mfussenegger/nvim-dap",
        version = false,
        dependencies = {
          { "jayp0521/mason-nvim-dap.nvim" },
        },
        opts = function()
          return {
            -- defaults = {
            --   fallback = {
            --     switchbuf = "newtab",
            --   },
            -- },
            languages = {
              adapters = {
                python = {
                  type = "executable",
                  command = "debugpy-adapter",
                  args = {},
                },
                codelldb = {
                  type = "server",
                  port = "${port}",
                  executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                  },
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
                rust = {
                  {
                    name = "Rust debug",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    showDisassembly = "never",
                    stopOnEntry = true,
                  },
                },
              },
            },
          }
        end,
        config = function(_, opts)
          local dap = require("dap")
          -- dap.defaults.fallback.switchbuf = opts.defaults.fallback.switchbuf
          for key, options in pairs(opts.languages) do
            for language, language_config in pairs(options) do
              dap[key][language] = language_config
            end
          end
          local debug = require("config.icons").debug
          vim.fn.sign_define("DapBreakpoint", {
            text = debug.breakpoint,
            texthl = "DebugBreakpoint",
            -- linehl = "DebugBreakpointLine",
            numhl = "DebugBreakpointLine",
          })
          vim.fn.sign_define("DapBreakpointCondition", {
            text = debug.condition,
            texthl = "DebugBreakpoint",
            -- linehl = "DebugBreakpointLine",
            numhl = "DebugBreakpointLine",
          })
          vim.fn.sign_define("DapStopped", {
            text = debug.stopped,
            texthl = "DebugStopped",
            -- linehl = "DebugStoppedLine",
            numhl = "DebugStoppedLine",
          })
          vim.fn.sign_define("DapBreakpointRejected", {
            text = debug.rejected,
            texthl = "DebugLogPoint",
            -- linehl = "DebugLogPointLine",
            numhl = "DebugLogPointLine",
          })
          vim.fn.sign_define("DapLogPoint", {
            text = debug.log,
            texthl = "DebugLogPoint",
            -- linehl = "DebugLogPointLine",
            numhl = "DebugLogPointLine",
          })
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
            close = { "<F4>", "<Esc>", "q" },
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
            },
            position = "bottom",
            size = 10,
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
      -- local dap = require("dap")
      local dapui = require("dapui")
      -- local neotree_open = require("helpers.toggle").is_neotree_open()

      dapui.setup(opts)
      -- dap.listeners.after.event_initialized["dapui_config"] = function()
      --   if neotree_open then
      --     vim.cmd.Neotree("close")
      --   end
      --   dapui.open()
      -- end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      --   if neotree_open then
      --     vim.cmd.Neotree("show")
      --   end
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      --   if neotree_open then
      --     vim.cmd.Neotree("show")
      --   end
      -- end
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
      ensure_installed = { "debugpy", "codelldb" },
    },
  },
}
