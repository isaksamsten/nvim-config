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

Toggle.format = require("helpers.format").toggle

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
