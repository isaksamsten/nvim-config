vim.cmd([[
  " command! -nargs=+ -complete=file Grep noautocmd silent grep! <args> | copen
  function! Grep(...)
      let s:command = join([&grepprg] + [expandcmd(join(a:000, ' '))], ' ')
      return system(s:command)
  endfunction

  command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
  command! -nargs=+ -complete=file_in_path -bar Rg  cgetexpr Grep(<f-args>)
  command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

  cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
  cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

  augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
                \| call setqflist([], 'a', {'title': ':' . s:command})
    autocmd QuickFixCmdPost lgetexpr lwindow
                \| call setloclist(0, [], 'a', {'title': ':' . s:command})
  augroup END
  command -nargs=0 -bar Errors :lua vim.diagnostic.setqflist { title = "Errors", severity = vim.diagnostic.severity.ERROR }
  command -nargs=0 -bar Warnings :lua vim.diagnostic.setqflist { title = "Warnings", severity = vim.diagnostic.severity.WARN }
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

local tools = {
  "bash-language-server",
  "bash-language-server",
  "clangd",
  "erlang-ls",
  "jdtls",
  "jedi-language-server",
  "json-lsp",
  "marksman",
  "ruff",
  "rust-analyzer",
  "texlab",
  "yaml-language-server",
  "zls",
}

vim.api.nvim_create_user_command("MasonInstallAll", function()
  local registry = require("mason-registry")
  for _, pkg_name in ipairs(tools) do
    local pkg = registry.get_package(pkg_name)
    if not pkg:is_installed() then
      vim.cmd("MasonInstall " .. pkg_name)
    end
  end
end, {})

vim.lsp.enable({
  "bashls",
  "clangd",
  "jdtls",
  "texlab",
  "zls",
  "basedpyright",
  "lua_ls",
  "jsonls",
  "marksman",
  "ruff",
  "rust_analyzer",
  "yamlls",
})
