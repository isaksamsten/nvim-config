return {
  "jedrzejboczar/toggletasks.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/toggleterm.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = function()
    local tt = require("telescope").extensions.toggletasks
    local function vertical(config)
      return require("telescope.themes").get_dropdown(config)
    end

    return {
      {
        "<leader>r",
        function()
          tt.spawn(vertical({ prompt_title = "Run task", previewer = false }))
        end,
        desc = "Run task",
      },
      {
        "<leader>g",
        function()
          tt.select(vertical({ prompt_title = "Running tasks" }))
        end,
        desc = "Running task",
      },
    }
  end,
  init = function(_)
    local Task = require("toggletasks.task")
    local discovery = require("toggletasks.discovery")

    function Task:has_tag(pattern)
      if not self.config.tags then
        return nil
      end

      for _, tag in ipairs(self.config.tags) do
        local match = string.match(tag, pattern)
        if match then
          return match
        end
      end
      return nil
    end
  end,
  opts = {
    toggleterm = {
      on_exit = function(term, job, exit_code, name)
        local Task = require("toggletasks.task")
        local task = Task.get(term._task_id)
        if not task then
          return
        end

        if exit_code == 0 and task:has_tag("exit_on_success") then
          task:shutdown()
        end
      end,
    },
  },
}
