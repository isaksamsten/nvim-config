local Toggle = {}

Toggle.virtual_text_state = {
  active = false,
  default_state = {
    spacing = 4,
    prefix = function(diagnostic)
      if diagnostic.source == "LTeX" then
        return ""
      end
      return require("config.icons"):get_diagnostic(diagnostic.severity)
    end,
    format = function(diagnostic)
      if diagnostic.source == "LTeX" then
        return ""
      end
      local max_width = vim.g.max_width_diagnostic_virtual_text or 40
      local message = diagnostic.message
      if #diagnostic.message > max_width + 1 then
        message = string.sub(diagnostic.message, 1, max_width) .. "…"
      end
      return message
    end,
  },
}

Toggle.virtual_text = function()
  if Toggle.virtual_text_state.active then
    Toggle.virtual_text_state.active = false
    vim.diagnostic.config({ better_virtual_text = false })
  else
    Toggle.virtual_text_state.active = true
    vim.diagnostic.config({ better_virtual_text = Toggle.virtual_text_state.default_state })
  end
end

Toggle.is_format_active = true
Toggle.format = function()
  if vim.b.is_format_active == false then
    Toggle.is_format_active = true
    vim.b.is_format_active = nil
  else
    Toggle.is_format_active = not Toggle.is_format_active
  end
  if Toggle.is_format_active then
    vim.notify("Format on save")
  end
end

Toggle.format_active = function()
  if vim.b.is_format_active == false or not Toggle.is_format_active then
    return false
  else
    return true and vim.bo.filetype ~= "mail"
  end
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

return Toggle
