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
    local display = nil
    local style = nil

    if fname == "" then
      display = "[No Name]"
    else
      fname = vim.fn.fnamemodify(fname, ":p:~:.")
      display = fname
    end

    -- local len = vim.fn.strchars(fname)
    -- if len > 20 then
    --   fname = "…" .. vim.fn.strpart(fname, len - 20, len, true)
    -- end

    return fname, display, style
  end

  local fname_limit = 1
  local lnum_limit = 1
  local col_limit = 1

  for _, item in ipairs(items) do
    local fname, display, style = get_item_fname(item)
    item._file = { filename = fname, display = display, style = style }
    local lnum = "" .. item.lnum
    local col = "" .. item.col

    if #display > fname_limit then
      fname_limit = #display
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
      local fname = item._file.filename
      local display = item._file.display
      local extension = vim.fn.fnamemodify(fname, ":t:e")
      local icon, icon_hl = require("nvim-web-devicons").get_icon(fname, extension)
      if not icon or icon == "nil" then
        icon = ""
        table.insert(highlights, { line = counter, group = "Comment", col = 0, end_col = #icon })
      else
        -- print(#icon)
        table.insert(highlights, { line = counter, group = icon_hl, col = 0, end_col = #icon })
      end

      if item._file.style then
        local highlight = item._file.style[1]
        table.insert(highlights, {
          line = counter,
          col = highlight[1][1] + #icon + 1,
          end_col = highlight[1][2] + #icon + 1,
          group = highlight[2],
        })
      end
      counter = counter + 1

      local lnum = "" .. item.lnum
      local col = "" .. item.col

      return ("%s %s | %s col %s%s | %s"):format(
        icon,
        display .. string.rep(" ", fname_limit - #display),
        string.rep(" ", lnum_limit - #lnum) .. lnum,
        col .. string.rep(" ", col_limit - #col),
        item.type == "" and "" or " " .. type_to_value(item.type),
        item.text:gsub("^%s+", ""):gsub("\n", " ")
      )
    else
      counter = counter + 1
      return item.text
    end
  end
  vim.schedule(function()
    local id = list.qfbufnr
    for _, hl in ipairs(highlights) do
      local col = hl.col
      local end_col = hl.end_col
      vim.highlight.range(id, namespace, hl.group, { hl.line, col }, { hl.line, end_col })
    end
  end)
  return vim.tbl_map(format_item, vim.list_slice(items, info.start_idx, info.end_idx))
end

function Update_titlestring(max_size)
  local fname = vim.fn.expand("%:t")
  if fname then
    if max_size and #fname > max_size - 2 then
      fname = fname:sub(0, max_size - 2) .. "⋯"
    end
    return fname
  else
    return ""
  end
end

vim.g.disable_iterm2_integration = true
vim.g.disable_codelens = true

vim.o.rulerformat = "%50(%=%{v:lua.Update_titlestring(22)}%#Comment# Ln: %l, Col: %c%V%)"
vim.o.titlestring = "nvim %{v:lua.Update_titlestring(22)}"
vim.o.quickfixtextfunc = [[{info -> v:lua.quickfixtextfunc(info)}]]

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.require'helpers'.foldexpr()"
  vim.opt.foldtext = ""
  -- vim.opt.fillchars = "fold: "
else
  vim.opt.foldmethod = "indent"
end

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
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "", foldsep = " ", diff = "╱" }
opt.title = true
-- opt.titlestring = "nvim %<%t%="
-- opt.titlestring = "{ %!v:lua._titlestring() }"
-- opt.selection = "exclusive"
opt.autowrite = true -- enable auto write

-- if not vim.env.SSH_TTY then
--   -- only set clipboard if not in ssh, to make sure the OSC 52
--   -- integration works automatically. Requires Neovim >= 0.10.0
--   -- opt.clipboard = "unnamedplus" -- Sync with system clipboard
-- end

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
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.winblend = 10 -- Window blend
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
opt.spell = false
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

opt.diffopt = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" }
-- end

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
