local icons = {
  ui = {
    cmd = "",
    search_up = "",
    search_down = "",
    filter = "",
    icons = "",
    help = ":h",
    git = "",
    remote = "",
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
  test = {
    failed = "",
    skipped = "",
    running = "",
    passed = "",
    unknown = "",
    running_animated = {
      "⠋",
      "⠙",
      "⠹",
      "⠸",
      "⠼",
      "⠴",
      "⠦",
      "⠧",
      "⠇",
      "⠏",
    },
  },
  indent = {
    collapsible = "─",
    prefix = "├",
    marker = "│",
    last = "└",
    collapsed = "─",
    expanded = "┐",
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

function icons:get_diagnostic(severity)
  severity = vim.diagnostic.severity[severity]
  if severity then
    local icon = self.diagnostics[severity:lower()]
    if icon then
      return icon
    end
  end
  return "!"
end

local diagnostics = icons.diagnostics
vim.fn.sign_define("DiagnosticSignError", { text = diagnostics.error, texthl = "DiagnosticSignError", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { text = diagnostics.warn, texthl = "DiagnosticSignWarn", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = diagnostics.info, texthl = "DiagnosticSignInfo", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = diagnostics.hint, texthl = "DiagnosticSignHint", numhl = "" })
return icons
