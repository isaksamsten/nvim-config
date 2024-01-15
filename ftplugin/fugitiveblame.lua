local win_alt = vim.fn.win_getid(vim.fn.winnr("#"))
vim.opt_local.winbar = vim.api.nvim_win_is_valid(win_alt) and vim.wo[win_alt].winbar ~= "" and " " or ""

vim.opt_local.number = false
vim.opt_local.signcolumn = "no"
vim.opt_local.relativenumber = false
