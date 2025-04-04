-- HACK: OK, so to get statuscol to work as expected this sign i suppose needs
-- to exist before it is loaded. But to get nvim-dap to register it it has to
-- be loaded after, so my solution is to load it both before and after...
local debug = require("config.icons").debug
vim.fn.sign_define("DapBreakpoint", {
  text = debug.breakpoint,
  texthl = "DebugBreakpoint",
  -- linehl = "DebugBreakpointLine",
  numhl = "DebugBreakpointLine",
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = debug.condition,
  texthl = "DebugBreakpoint",
  -- linehl = "DebugBreakpointLine",
  numhl = "DebugBreakpointLine",
})
vim.fn.sign_define("DapStopped", {
  text = debug.stopped,
  texthl = "DebugStopped",
  -- linehl = "DebugStoppedLine",
  numhl = "DebugStoppedLine",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = debug.rejected,
  texthl = "DebugLogPoint",
  -- linehl = "DebugLogPointLine",
  numhl = "DebugLogPointLine",
})
vim.fn.sign_define("DapLogPoint", {
  text = debug.log,
  texthl = "DebugLogPoint",
  -- linehl = "DebugLogPointLine",
  numhl = "DebugLogPointLine",
})
