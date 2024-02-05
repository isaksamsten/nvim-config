vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.api.nvim_create_user_command("Python", function(args)
  local python = require("helpers.python").python()
  if args ~= nil then
    if python then
      vim.notify(python.name .. " (" .. python.version .. ")")
    else
      vim.notify("No python environment")
    end
  end
end, {})
