local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local numpydoc_lint = h.make_builtin({
  name = "numpydoc-lint",
  meta = {
    url = "https://github.com/isaksamsten/numpydoc-lint/",
    description = "Find errors in Numpydoc formatted docstrings.",
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
    -- src/wildboar/datasets/_repository.py:985:5:985:5: I0009 Summary does not start with a capital letter

    on_output = h.diagnostics.from_pattern(
      [[(%d+):(%d+):(%d+):(%d+): ((%u)%w+) (.*)]],
      { "row", "col", "end_row", "end_col", "code", "severity", "message" },
      {
        severities = {
          E = h.diagnostics.severities["warning"],
          W = h.diagnostics.severities["information"],
          I = h.diagnostics.severities["hint"],
          H = h.diagnostics.severities["hint"],
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
