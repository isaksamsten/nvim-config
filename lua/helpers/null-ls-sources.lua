local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local numpydoc_lint = h.make_builtin({
  name = "numpydoc-lint",
  meta = {
    url = "https://github.com/isaksamsten/numpydoc-lint/",
    description = "Lint numpydoc",
  },
  method = DIAGNOSTICS,
  filetypes = { "python" },
  generator_opts = {
    command = "numpydoc-lint",
    args = { "--stdin-filename", "$FILENAME" },
    format = "line",
    check_exit_code = function(code)
      return code == 1
    end,
    to_stdin = true,
    ignore_stderr = true,
    on_output = h.diagnostics.from_pattern(
      [[(%d+):(%d+):(%d+):(%d+): ((%u)%w+) (.*)]],
      { "row", "col", "end_row", "end_col", "code", "severity", "message" },
      {
        severities = {
          G = h.diagnostics.severities["information"],
          S = h.diagnostics.severities["information"],
          P = h.diagnostics.severities["information"],
          R = h.diagnostics.severities["information"],
          Y = h.diagnostics.severities["information"],
          E = h.diagnostics.severities["information"],
        },
      }
    ),
  },
  factory = h.generator_factory,
})
return {
  diagnostics = {
    numpydoc_lint = numpydoc_lint,
  },
}
