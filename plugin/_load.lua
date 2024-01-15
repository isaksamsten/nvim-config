-- readline
vim.api.nvim_create_autocmd({ "CmdlineEnter", "InsertEnter" }, {
  group = vim.api.nvim_create_augroup("ReadlineSetup", {}),
  once = true,
  callback = function()
    require("plugin.readline").setup()
    return true
  end,
})
