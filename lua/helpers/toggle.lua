local Toggle = {}

Toggle.is_inlay_hint_active = true
Toggle.inlay_hint = function()
  Toggle.is_inlay_hint_active = not Toggle.is_inlay_hint_active
  vim.lsp.inlay_hint.enable(Toggle.is_inlay_hint_active)
end

Toggle.virtual_text_state = {
  active = false,
  default_state = {
    spacing = 4,
    prefix = function(diagnostic)
      return diagnostic.source == "LTeX" and "" or require("config.icons"):get_diagnostic(diagnostic.severity)
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
  Toggle.virtual_text_state.active = not Toggle.virtual_text_state.active
  vim.diagnostic.config({
    better_virtual_text = Toggle.virtual_text_state.active and Toggle.virtual_text_state.default_state or false,
  })
end

Toggle.is_format_active = true
Toggle.format = function()
  Toggle.is_format_active = not Toggle.is_format_active
  vim.b.is_format_active = Toggle.is_format_active and nil or false
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
  Toggle.is_diagnostics_active = not Toggle.is_diagnostics_active
  vim.diagnostic.enable(Toggle.is_diagnostics_active)
end

return Toggle
