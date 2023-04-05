local python = require("helpers.python")

vim.keymap.set("n", "<leader>ca", function()
  python.select_conda(function(env)
    if python.activate(env) then
      vim.cmd(":LspRestart<CR>")
    end
  end)
end, { desc = "Select virtual environment", silent = false })

vim.keymap.set("n", "<localleader>a", function()
  python.activate()
end, { desc = "Activate virtual environment" })
