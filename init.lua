vim.cmd([[
  command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | copen
  command! -nargs=+ -complete=file LGrep noautocmd silent lgrep! <args> | lopen
]])

-- Until telescope#3109 has been merged -- i think it is my last deprecation
vim.deprecate = function() end
vim.cmd.colorscheme("dragon")
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.signs")
