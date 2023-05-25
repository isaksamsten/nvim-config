local Toggle = {}
Toggle.is_conceal_active = vim.g.conceallevel == 3
Toggle.conceal = function()
  if Toggle.is_conceal_active then
    vim.opt_local["conceallevel"] = 0
  else
    vim.opt_local["conceallevel"] = 3
  end
  Toggle.is_conceal_active = not Toggle.is_conceal_active
end

local Format = require("helpers.format")
Toggle.is_format_active = Format.format_on_save
Toggle.format = function()
  Format.toggle()
  Toggle.is_format_active = Format.format_on_save
end

Toggle.is_diagnostics_active = true
function Toggle.diagnostics()
  if Toggle.is_diagnostics_active then
    vim.diagnostic.disable()
  else
    vim.diagnostic.enable()
  end
  Toggle.is_diagnostics_active = not Toggle.is_diagnostics_active
end

local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
Toggle.neotree_current_state = nil
Toggle.is_neotree_open = function()
  for _, source in ipairs(require("neo-tree").config.sources) do
    local state = manager.get_state(source)
    if state and renderer.window_exists(state) then
      Toggle.neotree_current_state = state
      return true
    end
  end
  return false
end

function Toggle.neotree()
  if Toggle.is_neotree_open() then
    vim.cmd.Neotree("close")
  else
    manager.close_all("left")
    local current_win = vim.api.nvim_get_current_win()
    local state = Toggle.neotree_current_state or manager.get_state("filesystem")
    manager.navigate(state, nil, nil, function()
      vim.api.nvim_set_current_win(current_win)
    end, false)
    -- Buffers and git does not seem to use the callback
    -- TODO: fix in the future or report a bug.
    vim.api.nvim_set_current_win(current_win)
  end
end

-- Toggle neotree focus.
Toggle.neotree_current_window = nil
function Toggle.focus_neotree(source)
  local state = manager.get_state(source)
  local current_win = vim.api.nvim_get_current_win()
  local window_exists = renderer.window_exists(state)
  if state.winid == current_win then
    -- If the window is not yet set or gone, default to the right window
    local winid = vim.fn.win_getid(vim.fn.winnr("1l"))
    if
      Toggle.neotree_current_window
      and vim.api.nvim_win_is_valid(Toggle.neotree_current_window)
      and vim.api.nvim_win_get_tabpage(Toggle.neotree_current_window) == vim.api.nvim_get_current_tabpage()
    then
      winid = Toggle.neotree_current_window
    end
    vim.api.nvim_set_current_win(winid)
  else
    Toggle.neotree_current_window = current_win
    if window_exists then
      vim.api.nvim_set_current_win(state.winid)
    else
      manager.close_all("left")
      manager.navigate(state, nil, nil, nil, false)
    end
  end
end

return Toggle
