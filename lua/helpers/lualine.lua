local utils = require("lualine.utils.utils")
local highlight = require("lualine.highlight")

local diagnostics_message = require("lualine.component"):extend()

function diagnostics_message:init(options)
  diagnostics_message.super:init(options)
end

function diagnostics_message:update_status(is_focused)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
  if #diagnostics > 0 then
    local diag = diagnostics[1]
    for _, d in ipairs(diagnostics) do
      if d.severity < diag.severity then
        diagnostics = d
      end
    end
    local icons = require("config.icons").diagnostics
    icons = { icons.error, icons.warn, icons.info, icons.hint }
    return icons[diag.severity] .. diag.message
  else
    return ""
  end
end

return {
  diagnostics_message = diagnostics_message,
}
