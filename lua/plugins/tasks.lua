return {
  {
    -- dir = "/home/isak/projects/overseer.nvim",
    "isaksamsten/overseer.nvim",
    opts = {
      strategy = {
        "toggleterm",
        use_shell = true,
        on_create = function(t)
          local activate_command = require("helpers.python").activate_command()
          if activate_command then
            t:send(activate_command)
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
