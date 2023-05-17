local diagnostics = require("config.icons").diagnostics
vim.fn.sign_define("DiagnosticSignError", { text = diagnostics.error, texthl = "DiagnosticSignError", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { text = diagnostics.warn, texthl = "DiagnosticSignWarn", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = diagnostics.info, texthl = "DiagnosticSignInfo", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = diagnostics.hint, texthl = "DiagnosticSignHint", numhl = "" })

local debug = require("config.icons").debug
vim.fn.sign_define("DapBreakpoint", {
  text = debug.breakpoint,
  texthl = "DebugBreakpoint",
  linehl = "DebugBreakpointLine",
  numhl = "DebugBreakpointLine",
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = debug.condition,
  texthl = "DebugBreakpoint",
  linehl = "DebugBreakpointLine",
  numhl = "DebugBreakpointLine",
})
vim.fn.sign_define(
  "DapStopped",
  { text = debug.stopped, texthl = "DebugStopped", linehl = "DebugStoppedLine", numhl = "DebugStoppedLine" }
)
vim.fn.sign_define("DapBreakpointRejected", {
  text = debug.rejected,
  texthl = "DebugLogPoint",
  linehl = "DebugLogPointLine",
  numhl = "DebugLogPointLine",
})
vim.fn.sign_define(
  "DapLogPoint",
  { text = debug.log, texthl = "DebugLogPoint", linehl = "DebugLogPointLine", numhl = "DebugLogPointLine" }
)
