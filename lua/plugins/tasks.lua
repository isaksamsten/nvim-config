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
      form = {
        border = require("config.icons").borders.outer.all,
      },
      task_list = { direction = "right" },
    },
    keys = {
      { "<leader>rb", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ob", "<cmd>OverseerToggle<cr>", desc = "Build tasks" },
    },
  },
}
