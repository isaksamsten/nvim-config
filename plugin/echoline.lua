local icons = require("config.icons")
local toggle = require("helpers.toggle")

local function get_toggles(opts)
  opts = opts or {}
  return function()
    local messages = {}
    if toggle.format_active() then
      table.insert(messages, { " ", "Normal" })
    else
      table.insert(messages, { " ", "Normal" })
    end

    local conceal_value = vim.api.nvim_win_get_option(0, "conceallevel")
    if conceal_value > 0 then
      table.insert(messages, { " ", "Normal" })
    else
      table.insert(messages, { " ", "Normal" })
    end

    local wrap = vim.api.nvim_win_get_option(0, "wrap")
    if wrap then
      table.insert(messages, { " ", "Normal" })
    end

    return messages
  end
end

local function buf_get_var(bufnr, key)
  local ok, value = pcall(vim.api.nvim_buf_get_var, bufnr, key)
  if ok then
    return value
  end
  return nil
end

local function get_git_dict(bufnr)
  local git_dict = buf_get_var(bufnr, "gitsigns_status_dict")
  if git_dict and git_dict.head then
    return git_dict
  end
  return nil
end

local function get_commits_since_last_push()
  local current_branch = vim.trim(vim.fn.system("git branch --show-current"))
  local tracking_branch = "origin/" .. current_branch
  local result = vim.fn.system(string.format("git rev-list --count %s..HEAD", tracking_branch))

  if vim.v.shell_error ~= 0 then
    return
  end

  return vim.trim(result)
end

local function git_branch(opts)
  opts = opts or {}
  return function()
    local icon = opts.icon or icons.git.branch .. " "
    local git_dict = get_git_dict(0)
    if git_dict then
      return { { icon .. git_dict.head .. " " .. get_commits_since_last_push() .. "" } }
    else
      return nil
    end
  end
end

local function git_changes(opts)
  opts = opts or {}
  return function()
    local git_dict = get_git_dict(0)
    if git_dict then
      local components = opts.components or { "added", "changed", "removed" }
      local icon = opts.icons or { changed = icons.git.change, added = icons.git.add, removed = icons.git.delete }
      local hl_group = opts.hl_groups
        or { changed = "GitSignsChange", added = "GitSignsAdd", removed = "GitSignsDelete" }
      local part = {}
      for _, component in ipairs(components) do
        local count = git_dict[component]
        if count and count > 0 then
          table.insert(part, { icon[component] .. " " .. count .. " ", hl_group[component] })
        end
      end
      return part
    else
      return nil
    end
  end
end

local function get_diagnostics(opts)
  opts = opts or {}
  return function()
    local diagnostics = vim.diagnostic.get(0)
    local signs = { "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignHint", "DiagnosticSignInfo" }
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

    local output = {}
    for _, sign in ipairs(signs) do
      local count = counts[sign]
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
end

local function get_python_venv(opts)
  opts = opts or {}
  return function()
    if vim.bo.filetype ~= "python" then
      return nil
    end

    local python = require("helpers.python")
    local venv = python.python()
    if venv ~= nil then
      local icon = opts.icon or " "
      return {
        { icon, opts.icon_hl or "Normal" },
        { opts.label or "Python ", opts.label_hl },
        { venv.version, opts.version_hl },
        { " (" .. venv.name .. ")", opts.venv_hl },
      }
    else
      return nil
    end
  end
end

local function get_full_width()
  return vim.api.nvim_get_option("columns")
end

local function get_current_filename(opts)
  opts = opts or {}
  return function()
    local expand
    if get_full_width() < 80 then
      expand = opts.short_expand or "%:t"
    else
      expand = opts.expand or "%:~:."
    end
    local filename = vim.fn.expand(expand)
    local extension = vim.fn.expand("%:t:e")
    local icon, icon_hl = require("nvim-web-devicons").get_icon(filename, extension)
    local part = {}
    if filename ~= "" then
      if icon then
        table.insert(part, { icon, icon_hl })
      else
        table.insert(part, { icons.file.file })
      end
      table.insert(part, { " " .. filename })
    end
    return part
  end
end

local function right_align(text_width, rep, hl_group)
  local win_width = get_full_width()
  local padding = win_width - text_width
  if padding <= 0 then
    return nil
  end
  rep = rep or " "
  hl_group = hl_group or "Normal"
  return { string.rep(rep, padding), hl_group }
end

local function separator(sep)
  return function()
    return { { sep } }
  end
end

local named_components = { separator = separator(" ") }

local function create_components(components)
  local result_list = {}
  for _, component in ipairs(components) do
    local part
    if component.callback ~= nil then
      part = component.callback()
    else
      part = named_components[component[1]]()
    end

    local message_list = {}
    local total_length = 0
    if part ~= nil then
      for _, msg_part in ipairs(part) do
        table.insert(message_list, msg_part)
        total_length = total_length + vim.fn.strwidth(msg_part[1])
      end
      if total_length > 0 then
        table.insert(result_list, {
          component[1],
          messages = message_list,
          total_length = total_length,
          priority = component.priority,
          required = component.required,
        })
      end
    end
  end
  return result_list
end

local function filter_components(components, win_width)
  local index = #components
  while components[index][1] == "padding" or components[index][1] == "separator" do
    table.remove(components, #components)
    index = index - 1
  end

  local sorted_components = {}
  local separator_length = 0
  for _, component in ipairs(components) do
    table.insert(sorted_components, component)
    if component[1] == "separator" then
      separator_length = separator_length + component.total_length
    end
  end

  table.sort(sorted_components, function(a, b)
    if a.priority and b.priority then
      return a.priority > b.priority
    elseif a.priority then
      return true
    elseif b.priority then
      return false
    else
      return false
    end
  end)

  local total_length = 30 + separator_length
  local retained = {}
  for _, component in ipairs(sorted_components) do
    total_length = total_length + component.total_length
    if total_length <= win_width then
      table.insert(retained, component)
    end
  end

  local result = {}
  for _, orig in ipairs(components) do
    if orig[1] == "separator" then
      table.insert(result, orig)
    else
      for _, retain in ipairs(retained) do
        if orig == retain then
          table.insert(result, orig)
        end
      end
    end
  end

  local any_non_sep = false
  for _, orig in ipairs(result) do
    if orig[1] ~= "separator" then
      any_non_sep = true
      break
    end
  end
  if any_non_sep then
    return result
  else
    return {}
  end
end

local function render_components(components)
  local messages = {}
  for _, component in ipairs(components) do
    for _, message in ipairs(component.messages) do
      table.insert(messages, message)
    end
  end

  return messages
end

local function generate_components()
  local left = {
    { "git", callback = git_branch(), priority = 1 },
    { "separator" },
    { "git_changes", callback = git_changes(), priority = 0 },
    { "separator" },
    { "filename", callback = get_current_filename(), priority = 3 },
  }
  local right = {
    { "diagnostics", callback = get_diagnostics(), priority = 1 },
    { "separator" },
    { "toggles", callback = get_toggles(), priority = 1 },
    { "separator" },
    {
      "python_venv",
      callback = get_python_venv({
        label_hl = "Comment",
        version_hl = "Comment",
        venv_hl = "Comment",
      }),
      priority = 1,
    },
  }

  local components = create_components(left)

  if vim.tbl_count(right) > 0 then
    local right_components = create_components(right)
    local padding_size = 0
    for _, component in ipairs(components) do
      padding_size = padding_size + component.total_length
    end
    for _, component in ipairs(right_components) do
      padding_size = padding_size + component.total_length
    end
    local padding = right_align(padding_size + 30)
    if padding ~= nil then
      table.insert(
        components,
        { "padding", messages = { padding }, priority = -1, total_length = vim.fn.strwidth(padding[1]) }
      )
    end
    for _, component in ipairs(right_components) do
      table.insert(components, component)
    end
  end
  local total_length = 30
  for _, component in ipairs(components) do
    total_length = total_length + component.total_length
  end
  local win_width = get_full_width()
  if total_length > win_width then
    components = filter_components(components, win_width)
  end

  return render_components(components)
end

local function rulerline()
  local messages = generate_components()
  local output = ""
  for _, message in ipairs(messages) do
    local highlight = "Normal"
    if message[2] then
      highlight = message[2]
    end
    output = output .. "%#" .. highlight .. "#" .. message[1]
  end
  return output
end

local can_run = true
vim.keymap.set("n", "<C-g>", function()
  if can_run then
    can_run = false
    local rulerformat = vim.o.rulerformat
    -- vim.o.rulerformat = "%#Comment#%l,%c%V%=%P"
    vim.o.rulerformat = "%=%#Comment# Ln: %l, Col: %c%V"
    local messages = generate_components()
    vim.api.nvim_echo(messages, false, {})
    vim.defer_fn(function()
      vim.api.nvim_echo({}, false, {})
      vim.o.rulerformat = rulerformat
      can_run = true
    end, 2000)
  end
end, { noremap = true, silent = true })
vim.o.rulerformat = "%50(%= %-t%#Comment# Ln: %l, Col: %c%V%)"
