local python = require("helpers.python")

vim.keymap.set("n", "<localleader>v", python.select_conda, { desc = "Select virtual environment" })
vim.keymap.set("n", "<localleader>u", function()
  python.write_pyrightconfig()
  vim.cmd(":LspRestart<CR>")
end, { desc = "Restart update Pyright and restart" })
