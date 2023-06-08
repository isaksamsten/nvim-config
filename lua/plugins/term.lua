return {
  {
    "akinsho/toggleterm.nvim",
    version = false,
    event = "VeryLazy",
    opts = {
      shade_terminals = false,
      open_mapping = [[<c-\>]],
      highlights = {
        Normal = {
          link = "NormalFloat",
        },
      },
      on_create = function(terminal)
        local Python = require("helpers.python")
        if not Python.is_activated then
          local activate_command = Python.activate_command()
          if activate_command then
            terminal:send(activate_command)
          end
        end
      end,
    },
  },
}
