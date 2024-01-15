-- https://github.com/Bekaboo/nvim/blob/master/lua/plugin/readline.lua
-- GPLv3
local M = {}
local api = vim.api
local fn = vim.fn
local map = vim.keymap.set
local col = vim.fn.col
local line = vim.fn.line

local regex_keyword_at_beginning = vim.regex([=[^\s*[[:keyword:]]*]=])
local regex_nonkeyword_at_beginning = vim.regex([=[^\s*[^[:keyword:] ]*]=])
local regex_keyword_at_end = vim.regex([=[[[:keyword:]]*\s*$]=])
local regex_nonkeyword_at_end = vim.regex([=[[^[:keyword:] ]*\s*$]=])

---Check if string is empty
---@param str string
---@return boolean
local function str_isempty(str)
  return str:gsub("%s+", "") == ""
end

---Match non-empty string
---@param str string
---@vararg vim.regex compiled vim regex
---@return string
local function match_nonempty(str, ...)
  local patterns = { ... }
  local capture = ""
  for _, pattern in ipairs(patterns) do
    local match_start, match_end = pattern:match_str(str)
    capture = match_start and str:sub(match_start + 1, match_end) or capture
    if not str_isempty(capture) then
      return capture
    end
  end
  return capture
end

---Get current line
---@return string
local function get_current_line()
  return fn.mode() == "c" and fn.getcmdline() or api.nvim_get_current_line()
end

---Get current column number
---@return integer
local function get_current_col()
  return fn.mode() == "c" and fn.getcmdpos() or col(".")
end

---Get character relative to cursor
---@param offset number from cursor
---@return string character
local function get_char(offset)
  local idx = get_current_col() + offset
  return get_current_line():sub(idx, idx)
end

---Get word after cursor
---@param str string? content of the line, default to current line
---@param colnr integer? column number, default to current column
---@return string
local function get_word_after(str, colnr)
  str = str or get_current_line()
  colnr = colnr or get_current_col()
  return match_nonempty(str:sub(colnr), regex_keyword_at_beginning, regex_nonkeyword_at_beginning)
end

---Get word before cursor
---@param str string? content of the line, default to current line
---@param colnr integer? column number, default to current column - 1
---@return string
local function get_word_before(str, colnr)
  str = str or get_current_line()
  colnr = colnr or get_current_col() - 1
  return match_nonempty(str:sub(1, colnr), regex_keyword_at_end, regex_nonkeyword_at_end)
end

---Check if current line is the last line
---@return boolean
local function last_line()
  return fn.mode() == "c" or line(".") == line("$")
end

---Check if current line is the first line
---@return boolean
local function first_line()
  return fn.mode() == "c" or line(".") == 1
end

---Check if cursor is at the end of the line
---@return boolean
local function end_of_line()
  return get_current_col() == #get_current_line() + 1
end

---Check if cursor is at the start of the line
---@return boolean
local function start_of_line()
  return get_current_col() == 1
end

---Check if cursor is at the middle of the line
---@return boolean
local function mid_of_line()
  local current_col = get_current_col()
  return current_col > 1 and current_col <= #get_current_line()
end

---Set up key mappings
function M.setup()
  if vim.g.loaded_readline then
    return
  end
  vim.g.loaded_readline = true

  map("!", "<C-a>", "<Home>")
  map("!", "<C-e>", "<End>")
  map("!", "<C-d>", "<Del>")
  map("c", "<C-b>", "<Left>")
  map("c", "<C-f>", "<Right>")
  map("c", "<C-_>", "<C-f>")
  map("c", "<M-e>", "<C-f>")
  map("!", "<C-BS>", "<C-w>")
  map("!", "<M-BS>", "<C-w>")
  map("!", "<M-Del>", "<C-w>")

  map("!", "<C-y>", 'pumvisible() ? "<C-y>" : "<C-r>-"', { expr = true })
  map("c", "<C-k>", "<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>")

  map("i", "<C-b>", function()
    if first_line() and start_of_line() then
      return "<Ignore>"
    end
    return start_of_line() and "<Up><End>" or "<Left>"
  end, { expr = true })
  map("i", "<C-f>", function()
    if last_line() and end_of_line() then
      return "<Ignore>"
    end
    return end_of_line() and "<Down><Home>" or "<Right>"
  end, { expr = true })
  map("i", "<C-k>", function()
    return "<C-g>u" .. (end_of_line() and "<Del>" or "<Cmd>normal! D<CR><Right>")
  end, { expr = true })
  map("!", "<C-t>", function()
    if fn.getcmdtype():match("[?/]") then
      return "<C-t>"
    end
    if start_of_line() and not first_line() then
      local char_under_cur = get_char(0)
      if char_under_cur ~= "" then
        return "<Del><Up><End>" .. char_under_cur .. "<Down><Home>"
      else
        local lnum = line(".")
        local prev_line = fn.getline(lnum - 1) --[[@as string]]
        local char_end_of_prev_line = prev_line:sub(-1)
        if char_end_of_prev_line ~= "" then
          return "<Up><End><BS><Down><Home>" .. char_end_of_prev_line
        end
        return ""
      end
    end
    if end_of_line() then
      local char_before = get_char(-1)
      if get_char(-2) ~= "" or fn.mode() == "c" then
        return "<BS><Left>" .. char_before .. "<End>"
      else
        return "<BS><Up><End>" .. char_before .. "<Down><End>"
      end
    end
    if mid_of_line() then
      return "<BS><Right>" .. get_char(-1)
    end
  end, { expr = true })
  map("!", "<C-u>", function()
    if not start_of_line() then
      fn.setreg("-", get_current_line():sub(1, get_current_col() - 1))
    end
    return fn.mode() == "c" and "<C-u>" or "<C-g>u<C-u>"
  end, { expr = true })
  map("!", "<M-b>", function()
    local word_before = get_word_before()
    if not str_isempty(word_before) or fn.mode() == "c" then
      return string.rep("<Left>", #word_before)
    end
    -- No word before cursor and is in insert mode
    local current_linenr = line(".")
    local target_linenr = fn.prevnonblank(current_linenr - 1)
    target_linenr = target_linenr ~= 0 and target_linenr or 1
    local line_str = fn.getline(target_linenr) --[[@as string]]
    return (current_linenr == target_linenr and "" or "<End>")
      .. string.rep("<Up>", current_linenr - target_linenr)
      .. string.rep("<Left>", #get_word_before(line_str, #line_str))
  end, { expr = true })
  map("!", "<M-f>", function()
    local word_after = get_word_after()
    if not str_isempty(word_after) or fn.mode() == "c" then
      return string.rep("<Right>", #word_after)
    end
    -- No word after cursor and is in insert mode
    local current_linenr = line(".")
    local target_linenr = fn.nextnonblank(current_linenr + 1)
    target_linenr = target_linenr ~= 0 and target_linenr or line("$")
    local line_str = fn.getline(target_linenr) --[[@as string]]
    return (current_linenr == target_linenr and "" or "<Home>")
      .. string.rep("<Down>", target_linenr - current_linenr)
      .. string.rep("<Right>", #get_word_after(line_str, 1))
  end, { expr = true })
  map("!", "<M-d>", function()
    return (fn.mode() == "c" and "" or "<C-g>u") .. string.rep("<Del>", #get_word_after())
  end, { expr = true })
end

return M
