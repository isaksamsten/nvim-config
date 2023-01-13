return {

  {
    "rcarriga/nvim-dap-ui",
    event = "BufReadPre *.py",
    dependencies = {
      {
        "mfussenegger/nvim-dap",
        dependencies = {
          { "jayp0521/mason-nvim-dap.nvim" },
        },
        opts = {},
        config = function(_, opts)
          local python_path = vim.fn.exepath("python")
          local dap = require("dap")
          dap.adapters.python = {
            type = "executable",
            command = python_path,
            args = { "-m", "debugpy.adapter" },
          }
          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",

              program = "${file}",
              pythonPath = python_path,
            },
          }

          vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
          vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Condition: "))
          end, { desc = "Set breakpoint condition" })
          vim.keymap.set("n", "<leader>dr", dap.run_last, { desc = "Run last debug" })
          vim.keymap.set("n", "<leader>dR", dap.repl.open, { desc = "Open REPL" })

          vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "", linehl = "", numhl = "" })
          vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
          vim.fn.sign_define("DapStopped", { text = " ", texthl = "", linehl = "", numhl = "" })
          vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "", linehl = "", numhl = "" })
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
      { "VonHeikemen/lsp-zero.nvim" },
    },
    opts = {
      ensure_installed = {
        "python",
      },
    },
  },
}
