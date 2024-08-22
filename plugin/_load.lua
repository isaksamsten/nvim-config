-- readline
vim.api.nvim_create_autocmd({ "CmdlineEnter", "InsertEnter" }, {
  group = vim.api.nvim_create_augroup("ReadlineSetup", {}),
  once = true,
  callback = function()
    -- require("plugin.readline").setup()
    return true
  end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  once = true,
  pattern = "*.ipynb",
  group = vim.api.nvim_create_augroup("JupyTextSetup", {}),
  callback = function(info)
    require("plugin.jupytext").setup(info.buf)
    vim.cmd([[doautocmd BufReadPost]])
    return true
  end,
})
