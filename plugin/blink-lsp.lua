vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities({
    textDocument = { completion = { completionItem = { snippetSupport = false } } },
  }),
})
