return {
  {
    "akinsho/toggleterm.nvim",
    version = false,
    event = "VeryLazy",
    opts = {
      open_mapping = [[<c-\>]],
      on_create = function(terminal)
        local Python = require("helpers.python")
        if not Python.is_activated() then
          local activate_command = Python.activate_command()
          if activate_command then
            terminal:send(activate_command)
          end
        end
      end,
    },
  },
}
