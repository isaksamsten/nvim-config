local namespace = vim.api.nvim_create_namespace("iqf")

function _G.quickfixtextfunc(info)
  local items, list
  if info.quickfix > 0 then
    list = vim.fn.getqflist({ id = info.id, items = 0, qfbufnr = 1 })
  else
    list = vim.fn.getloclist(info.winid, { id = info.id, items = 0, qfbufnr = 1 })
  end
  items = list.items

  local max_width = vim.api.nvim_get_option("columns")
  local function get_item_fname(item)
    local fname = item.bufnr > 0 and vim.fn.bufname(item.bufnr) or ""

    if fname == "" then
      fname = "[No Name]"
    else
      fname = vim.fn.fnamemodify(fname, ":p:~:.")
    end

    local len = vim.fn.strchars(fname)
    if len > 20 then
      fname = "…" .. vim.fn.strpart(fname, len - 20, len, true)
    end

    return fname
  end

  local fname_limit = 1
  local lnum_limit = 1
  local col_limit = 1

  for _, item in ipairs(items) do
    local fname = get_item_fname(item)
    local lnum = "" .. item.lnum
    local col = "" .. item.col

    if #fname > fname_limit then
      fname_limit = #fname
    end
    if #lnum > lnum_limit then
      lnum_limit = #lnum
    end
    if #col > col_limit then
      col_limit = #col
    end
  end

  local function type_to_value(type)
    if type == "E" then
      return "error"
    elseif type == "W" then
      return "warning"
    elseif type == "N" then
      return "note"
    elseif type == "I" then
      return "info"
    end
    return type
  end

  local highlights = {}
  local counter = 0
  local function format_item(item)
    if item.valid == 1 then
      local fname = get_item_fname(item)
      local extension = vim.fn.fnamemodify(fname, ":t:e")
      local icon, icon_hl = require("nvim-web-devicons").get_icon(fname, extension)
      if not icon or icon == "nil" then
        icon = ""
      else
        table.insert(highlights, { line = counter, group = icon_hl })
      end
      counter = counter + 1

      local lnum = "" .. item.lnum
      local col = "" .. item.col

      return ("%s  %s | %s col %s%s | %s"):format(
        icon,
        fname .. string.rep(" ", fname_limit - #fname),
        string.rep(" ", lnum_limit - #lnum) .. lnum,
        col .. string.rep(" ", col_limit - #col),
        item.type == "" and "" or " " .. type_to_value(item.type),
        item.text:gsub("^%s+", ""):gsub("\n", " ")
      )
    else
      return item.text
    end
  end
  vim.schedule(function()
    local id = list.qfbufnr
    for _, hl in ipairs(highlights) do
      vim.highlight.range(id, namespace, hl.group, { hl.line, 0 }, { hl.line, 2 })
    end
  end)
  return vim.tbl_map(format_item, vim.list_slice(items, info.start_idx, info.end_idx))
end

_G.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())

function _G.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if _G.skip_foldexpr[buf] then
    return "0"
  end

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  _G.skip_foldexpr[buf] = true
  skip_check:start(function()
    _G.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

vim.o.quickfixtextfunc = [[{info -> v:lua.quickfixtextfunc(info)}]]
vim.o.foldtext = ""
vim.o.foldexpr = "v:lua.foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.o.exrc = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.no_plugin_maps = true
vim.g.cmp_completion_max_width = 30
vim.g.max_width_diagnostic_virtual_text = 50

local opt = vim.opt
vim.opt.fillchars = { eob = " ", fold = ".", foldopen = "", foldclose = "", foldsep = " " }
opt.title = true
-- opt.titlestring = "%<%t%="
-- opt.selection = "exclusive"
opt.autowrite = true -- enable auto write
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.cmdheight = 1
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true
-- opt.cursorlineopt = "number"
opt.conceallevel = 2 -- Hide * markup for bold and italic
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
opt.laststatus = 0
vim.opt.statusline = "%#WinSeparator#%{%v:lua.string.rep('—', v:lua.vim.fn.winwidth(0))%}"
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
-- opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 4 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en", "sv" }
opt.spell = true
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
-- if vim.fn.has("nvim-0.9.0") == 1 then
opt.splitkeep = "screen"
opt.shortmess:append({ C = true })
-- end

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
