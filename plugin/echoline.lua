local icons = require("config.icons")
local function get_git_branch()
  local handle = io.popen("git branch --show-current 2> /dev/null")
  if handle ~= nil then
    local branch = handle:read("*a"):gsub("\n", "")
    handle:close()
    return branch
  else
    return ""
  end
end

local function get_diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  local counts = { DiagnosticSignError = 0, DiagnosticSignWarn = 0, DiagnosticSignHint = 0, DiagnosticSignInfo = 0 }
  for _, diag in ipairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      counts.DiagnosticSignError = counts.DiagnosticSignError + 1
    elseif diag.severity == vim.diagnostic.severity.WARN then
      counts.DiagnosticSignWarn = counts.DiagnosticSignWarn + 1
    elseif diag.severity == vim.diagnostic.severity.INFO then
      counts.DiagnosticSignInfo = counts.DiagnosticSignInfo + 1
    elseif diag.severity == vim.diagnostic.severity.HINT then
      counts.DiagnosticSignHint = counts.DiagnosticSignHint + 1
    end
  end
  print(vim.inspect(counts))

  local output = {}
  for sign, count in pairs(counts) do
    sign = vim.fn.sign_getdefined(sign)
    if sign and #sign > 0 then
      sign = sign[1]
      if count > 0 then
        table.insert(output, { count .. " " .. sign.text, sign.texthl })
      end
    end
  end
  if #output > 0 then
    table.insert(output, 1, { "  " })
  end
  return output
end

local function show_custom_info()
  local filename = vim.fn.expand("%:~:.")
  local extension = vim.fn.expand("%:t:e")
  local branch = get_git_branch()
  local diagnostics = get_diagnostics()

  local message = {}

  table.insert(message, { icons.git.branch .. " " .. branch })
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(message, diagnostic)
  end

  local icon, icon_hl = require("nvim-web-devicons").get_icon(filename, extension)
  if filename ~= "" then
    if icon then
      table.insert(message, { "  " .. icon, icon_hl })
    else
      table.insert(message, { "  " .. icons.file.file })
    end
    table.insert(message, { " " .. filename .. " " })
  end
  vim.api.nvim_echo(message, false, {})
end
vim.keymap.set("n", "<C-g>", show_custom_info, { noremap = true, silent = true })
