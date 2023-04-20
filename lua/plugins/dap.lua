return {

  {
    "rcarriga/nvim-dap-ui",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- "MunifTanjim/nui.nvim",
        "mfussenegger/nvim-dap",
        dependencies = {
          { "jayp0521/mason-nvim-dap.nvim" },
        },
        opts = {},
        config = function(_, opts)
          local executable = require("helpers.python").executable
          local icons = require("config.icons").debug
          local dap = require("dap")
          dap.adapters.python = {
            type = "executable",
            command = "debugpy-adapter",
            args = {},
          }
          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",

              program = "${file}",
              pythonPath = executable,
            },
          }

          vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
          vim.keymap.set("n", "<leader>dB", function()
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
                style = "single",
                text = {
                  top = "Condition: ",
                  top_align = "left",
                },
              },
              win_options = {
                winhighlight = "Normal:Normal",
              },
            }

            local input = Input(popup_options, {
              on_submit = function(value)
                dap.set_breakpoint(value)
              end,
            })
            input:map("n", "<Esc>", function()
              input:unmount()
            end, { noremap = true })
            input:on(event.BufLeave, function()
              input:unmount()
            end)
            input:mount()
          end, { desc = "Set conditional breakpoint" })
          vim.keymap.set("n", "<leader>dr", dap.run_last, { desc = "Run last debug" })
          vim.keymap.set("n", "<leader>dR", dap.repl.open, { desc = "Open REPL" })
          vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
          vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
          vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
          vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })

          vim.fn.sign_define("DapBreakpoint", {
            text = icons.breakpoint,
            texthl = "DebugBreakpoint",
            linehl = "DebugBreakpoint",
            numhl = "DebugBreakpoint",
          })
          vim.fn.sign_define("DapBreakpointCondition", {
            text = icons.condition,
            texthl = "DapBreakpointCondition",
            linehl = "DapBreakpointCondition",
            numhl = "DapBreakpointCondition",
          })
          vim.fn.sign_define(
            "DapStopped",
            { text = icons.stopped, texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
          )
          vim.fn.sign_define("DapBreakpointRejected", {
            text = icons.rejected,
            texthl = "DapBreakpointRejected",
            linehl = "DapBreakpointRejected",
            numhl = "DapBreakpointRejected",
          })
          vim.fn.sign_define(
            "DapLogPoint",
            { text = icons.log, texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
          )
        end,
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    "jayp0521/mason-nvim-dap.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },
    },
    opts = {
      ensure_installed = {},
    },
  },
}
