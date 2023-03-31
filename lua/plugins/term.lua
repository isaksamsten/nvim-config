return {
  {
    "akinsho/toggleterm.nvim",
    version = false,
    event = "VeryLazy",
    opts = {
      open_mapping = [[<c-\>]],
      on_create = function(terminal)
        local activate_command = require("helpers.python").activate_command()
        if activate_command then
          terminal:send(activate_command)
        end
      end,
    },
  },
}
