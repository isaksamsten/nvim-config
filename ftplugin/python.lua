vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.b.inlay_hint_disable = true

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

require("which-key").add({
  { "<leader>a", group = "Python", icon = { cat = "filetype", name = "python" } },

  {
    "<leader>aA",
    function()
      Python.select_conda({
        callback = function(env)
          if Python.activate(env) then
            vim.cmd("LspRestart<CR>")
          end
        end,
      })
    end,
    desc = "Select environtment",
  },
  {
    "<leader>aa",
    function()
      Python.activate()
    end,
    desc = "Activate Python environment",
    silent = false,
  },
  {
    "<leader>as",
    function()
      Python.select_conda({
        callback = function(env)
          if env then
            Python.write_pyrightconfig(env)
          end
        end,
        force = true,
      })
    end,
    desc = "Save virtual environment",
  },
})
