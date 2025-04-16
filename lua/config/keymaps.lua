-- vim.keymap.set("n", "<Left>", "<C-w>h", { desc = "Go to left window" })
-- vim.keymap.set("n", "<Right>", "<C-w>l", { desc = "Go to right window" })
-- vim.keymap.set("n", "<Down>", "<C-w>j", { desc = "Go to lower window" })
-- vim.keymap.set("n", "<Up>", "<C-w>k", { desc = "Go to upper window" })

-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

local function ToggleBackground()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end

vim.keymap.set("n", "<leader>ub", ToggleBackground, { noremap = true, silent = true, desc = "Background color" })
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Navigate according to displayed lines, not physical lines
vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
-- vim.keymap.set({ "n", "x" }, "$", [[v:count == 0 ? 'g$' : '$']], { expr = true })
-- vim.keymap.set({ "n", "x" }, "0", [[v:count == 0 ? 'g0' : '0']], { expr = true })

-- Save using ctrl-s
vim.keymap.set("n", "<C-S>", "<Cmd>silent! update | redraw<CR>", { desc = "Save" })
vim.keymap.set({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save and go to Normal mode" })

-- Reselect latest changed, put, or yanked text
vim.keymap.set(
  "n",
  "gV",
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, desc = "Visually select changed text" }
)

-- Search inside visually highlighted text.
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Search visually selected text
vim.keymap.set("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
vim.keymap.set("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

vim.keymap.set({ "n", "v" }, "]t", "<Esc><Cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set({ "n", "v" }, "[t", "<Esc><Cmd>tabprev<CR>", { desc = "Previous tab" })

vim.keymap.set({ "n", "v" }, "<leader>1", "<Esc><Cmd>tabnext 1<CR>", { desc = "Next tab" })
vim.keymap.set({ "n", "v" }, "<leader>2", "<Esc><Cmd>tabnext 2<CR>", { desc = "Next tab" })
vim.keymap.set({ "n", "v" }, "<leader>3", "<Esc><Cmd>tabnext 3<CR>", { desc = "Next tab" })
vim.keymap.set({ "n", "v" }, "<leader>4", "<Esc><Cmd>tabnext 4<CR>", { desc = "Next tab" })
vim.keymap.set({ "n", "v" }, "<leader>Tc", "<Esc><Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set({ "n", "v" }, "<leader>Tx", "<Esc><Cmd>tabclose<CR>", { desc = "Close tab" })

-- vim.keymap.set({ "n" }, "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
-- vim.keymap.set({ "n" }, "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
-- vim.keymap.set({ "n" }, "]Q", "<cmd>clast<cr>", { desc = "Last quickfix" })
-- vim.keymap.set({ "n" }, "[Q", "<cmd>cfirst<cr>", { desc = "First quickfix" })

-- Toggle
local Toggle = require("helpers.toggle")
vim.keymap.set("n", "<leader>uf", Toggle.format, { desc = "Format on save" })
vim.keymap.set("n", "<leader>ud", Toggle.virtual_text, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>ui", Toggle.inlay_hint, { desc = "Inlay hints" })

-- vim.keymap.set("n", "g,", function()
--   vim.diagnostic.open_float(nil, { scope = "line" })
-- end, { silent = true, desc = "Show diagnostics" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { silent = true, desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { silent = true, desc = "Next diagnostic" })

vim.keymap.set("n", "[x", function()
  vim.diagnostic.jump({ count = -1, float = false, severity = vim.diagnostic.severity.ERROR })
end, { silent = true, desc = "Previous error" })

vim.keymap.set("n", "]x", function()
  vim.diagnostic.jump({ count = 1, float = false, severity = vim.diagnostic.severity.ERROR })
end, { silent = true, desc = "Next error" })

local M = {}

function M.lsp_on_attach(client, bufnr)
  local map = function(m, lhs, rhs, desc)
    vim.keymap.set(m, lhs, rhs, { remap = false, silent = true, buffer = bufnr, desc = desc })
  end

  map({ "n", "v" }, "K", vim.lsp.buf.hover, "Show information")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
  if client:supports_method("textDocument/codeLens") and not vim.g.disable_codelens then
    map({ "n", "v" }, "grl", vim.lsp.codelens.run, "Code lens")
  end
end

return M
