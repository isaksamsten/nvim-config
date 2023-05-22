vim.cmd([[
  command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | redraw! | Trouble quickfix
  command! -nargs=+ -complete=file LGrep noautocmd silent lgrep! <args> | redraw! | Trouble loclist
]])

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.signs")
