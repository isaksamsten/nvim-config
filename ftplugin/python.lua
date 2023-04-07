local python = require("helpers.python")

vim.keymap.set("n", "<leader>ma", function()
  python.select_conda({
    callback = function(env)
      if python.activate(env) then
        vim.cmd(":LspRestart<CR>")
      end
    end,
  })
end, { desc = "Activate Conda environment", silent = false })

vim.keymap.set("n", "<leader>ms", function()
  python.select_conda({
    callback = function(env)
      if env then
        python.write_pyrightconfig(env)
      end
    end,
    force = true,
  })
end, { desc = "Select Conda environment" })
