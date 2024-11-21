vim.cmd([[
  command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | copen
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_perl_provider = 0
]])

if vim.env.TMUX ~= nil then
  vim.loop.fs_write(2, "\27Ptmux;\27\27]11;?\7\27\\", -1, nil)
end

-- Disable python3 provider
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.signs")
vim.cmd.colorscheme("dragon")
