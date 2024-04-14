local Toggle = {}

Toggle.is_format_active = true
Toggle.format = function()
  if vim.b.is_format_active == false then
    Toggle.is_format_active = true
    vim.b.is_format_active = nil
  else
    Toggle.is_format_active = not Toggle.is_format_active
  end
  if Toggle.is_format_active then
    vim.notify("Format on save is on")
  else
    vim.notify("Format on save is off")
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
