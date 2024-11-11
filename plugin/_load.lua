if vim.g.vscode then
  vim.fn["plugin#vscode#setup"]()
  return
end

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
