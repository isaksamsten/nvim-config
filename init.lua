vim.cmd([[
  command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | redraw! | copen
  command! -nargs=+ -complete=file LGrep noautocmd silent lgrep! <args> | redraw! | lopen
]])

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.signs")
