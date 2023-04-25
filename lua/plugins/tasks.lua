return {
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = {
        "toggleterm",
        use_shell = true,
        on_create = function(t)
          local Python = require("helpers.python")
          if not Python.is_activated then
            local activate_command = Python.activate_command()
            if activate_command then
              t:send(activate_command)
            end
          end
        end,
      },
      task_list = { direction = "right" },
    },
    keys = {
      { "<leader>r", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>g", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
    },
  },
}
