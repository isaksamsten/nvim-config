local icons = {
  ui = {
    cmd = " ",
    search_up = " ",
    search_down = " ",
    filter = " ",
    icons = " ",
    help = "󰋖 ",
    lua = "󰢱 ",
    git = " ",
    remote = " ",
    auto_format = "",
  },
  debug = {
    debug = "",
    breakpoint = "",
    condition = "",
    stopped = "",
    rejected = "",
    log = "",

    disconnect = "",
    pause = "",
    play = "",
    run_last = "",
    step_back = "",
    step_into = "",
    step_out = "",
    step_over = "",
    terminate = "",
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
    dotted_marker = "┆",
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
      add = "▎",
      topdelete = " ",
      delete = "▎",
      changedelete = "▎",
      change = "▎",
      untracked = "▎",
    },
    git = "",
    add = "",
    branch = "",
    change = "",
    conflict = "",
    delete = "",
    ignored = "◌",
    renamed = "",
    staged = "✓",
    unstaged = "✗",
    untracked = "*",
  },
  diagnostics = {
    error = " ",
    warn = " ",
    hint = "󰌶 ",
    info = " ",
  },
  kinds = {
    Copilot = "",
    Array = "",
    Boolean = "",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Key = "",
    Keyword = "",
    Method = "",
    Module = "",
    Namespace = "",
    Null = "ﳠ",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
    Unknown = "",
  },
  statuscol = "▏",
  indentline = "│",
  borders = {
    inner = {
      all = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" },
      top_bottom = { " ", "▁", " ", " ", " ", "▔", " ", " " },
    },
    outer = {
      -- all = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
      -- all = { "", "", "", "", "", "", "", "" },
      all = { " ", " ", " ", " ", " ", " ", " ", " " },
    },
    none = { "", "", "", "", "", "", "", "" },
    left_right = { "", "", " ", "", "", "", "", " " },
    empty = { " ", " ", " ", " ", " ", " ", " ", " " },
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

return icons
