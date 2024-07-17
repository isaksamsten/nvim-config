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

local Python = require("helpers.python")
vim.keymap.set("n", "<leader>AA", function()
  Python.select_conda({
    callback = function(env)
      if Python.activate(env) then
        vim.cmd("LspRestart<CR>")
      end
    end,
  })
end, { desc = "Select Conda environment", silent = false })

vim.keymap.set("n", "<leader>Aa", function()
  Python.activate()
end, { desc = "Activate Python environment", silent = false })

vim.keymap.set("n", "<leader>As", function()
  Python.select_conda({
    callback = function(env)
      if env then
        Python.write_pyrightconfig(env)
      end
    end,
    force = true,
  })
end, { desc = "Save virtual environment" })
