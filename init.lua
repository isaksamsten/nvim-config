vim.cmd([[
  command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | copen
  command! -nargs=+ -complete=file LGrep noautocmd silent lgrep! <args> | lopen
  let g:loaded_python3_provider = 0
  " let g:loaded_ruby_provider = 0
  " let g:loaded_perl_provider = 0
]])

-- Disable python3 provider
vim.cmd.colorscheme("dragon")
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.signs")
