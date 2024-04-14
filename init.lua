vim.cmd([[
  command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | copen
  command! -nargs=+ -complete=file LGrep noautocmd silent lgrep! <args> | lopen
]])

vim.cmd.colorscheme("dragon")
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.signs")
