vim.o.exrc = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.no_plugin_maps = true
vim.g.cmp_completion_max_width = 30
vim.g.max_width_diagnostic_virtual_text = 50

local opt = vim.opt
opt.title = true
opt.titlestring = "%<%t%= - Neovim"
opt.selection = "exclusive"
opt.autowrite = true -- enable auto write
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.cmdheight = 1
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true
opt.cursorlineopt = "number"
-- opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guifont = "Jetbrains Mono:h13"
opt.hidden = true -- Enable modified buffers in background
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.joinspaces = false -- No double spaces with join after a dot
opt.laststatus = 2
opt.foldenable = false
-- opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- enable mouse mode
opt.number = true -- Print line number
opt.relativenumber = false -- Relative line numbers
opt.pumblend = nil -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 4 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- minimum window width
opt.wrap = false -- Disable line wrap
opt.linebreak = true
if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
