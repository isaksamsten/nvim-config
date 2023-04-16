local icons = {
  ui = {
    cmd = "",
    search_up = "",
    search_down = "",
    filter = "",
    icons = "",
    help = ":h",
    git = "",
  },
  debug = {
    breakpoint = "",
    condition = "",
    stopped = "",
    rejected = "",
    log = "",
  },
  file = {
    file = "",
    modified = "",
    readonly = "",
    new = "",
  },

  indent = {
    marker = "│",
    last = "└",
  },
  folder = {
    closed = "",
    open = "",
    empty = "ﰊ",
    collapsed = "",
    expanded = "",
  },
  git = {
    signs = {
      add = "│",
      topdelete = "󱨉",
      delete = "│",
      changedelete = "│",
      change = "│",
      untracked = "│",
    },
    git = "",
    add = "",
    branch = "",
    change = "",
    conflict = "",
    delete = "",
    ignored = "◌",
    renamed = "",
    staged = "✓",
    unstaged = "✗",
    untracked = "★",
  },
  diagnostics = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = "ﳠ ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
}
icons.diagnostics.by_severity = function(severity)
  if severity == vim.diagnostic.severity.ERROR then
    return icons.diagnostics.error
  elseif severity == vim.diagnostic.severity.WARN then
    return icons.diagnostics.warn
  elseif severity == vim.diagnostic.severity.INFO then
    return icons.diagnostics.info
  else
    return icons.diagnostics.hint
  end
end

return icons
