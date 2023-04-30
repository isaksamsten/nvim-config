vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
vim.keymap.set("n", "<M-]>", "<C-w>w", { desc = "Go to next window" })
vim.keymap.set("n", "<M-]>", "-1<C-w>w", { desc = "Go to next window" })
-- vim.keymap.set("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })

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

-- Save using ctrl-s
vim.keymap.set("n", "<C-S>", "<Cmd>silent! update | redraw<CR>", { desc = "Save" })
vim.keymap.set({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save and go to Normal mode" })

-- Move using alt
vim.keymap.set("c", "<M-h>", "<Left>", { silent = false, desc = "Left" })
vim.keymap.set("c", "<M-l>", "<Right>", { silent = false, desc = "Right" })
vim.keymap.set("i", "<M-h>", "<Left>", { noremap = false, desc = "Left" })
vim.keymap.set("i", "<M-j>", "<Down>", { noremap = false, desc = "Down" })
vim.keymap.set("i", "<M-k>", "<Up>", { noremap = false, desc = "Up" })
vim.keymap.set("i", "<M-l>", "<Right>", { noremap = false, desc = "Right" })
vim.keymap.set("t", "<M-h>", "<Left>", { desc = "Left" })
vim.keymap.set("t", "<M-j>", "<Down>", { desc = "Down" })
vim.keymap.set("t", "<M-k>", "<Up>", { desc = "Up" })
vim.keymap.set("t", "<M-l>", "<Right>", { desc = "Right" })

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

vim.keymap.set({ "n", "v" }, "<M-]>", "<Esc><Cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set({ "n", "v" }, "<M-[>", "<Esc><Cmd>tabprev<CR>", { desc = "Previous tab" })

vim.keymap.set({ "n", "v" }, "<M-t>", "<Esc><Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set({ "n", "v" }, "<M-w>", "<Esc><Cmd>tabclose<CR>", { desc = "Close tab" })

local Python = require("helpers.python")
vim.keymap.set("n", "<leader>mA", function()
  Python.select_conda({
    callback = function(env)
      if Python.activate(env) then
        vim.cmd(":LspRestart<CR>")
      end
    end,
  })
end, { desc = "Select Conda environment", silent = false })

vim.keymap.set("n", "<leader>ms", function()
  Python.select_conda({
    callback = function(env)
      if env then
        Python.write_pyrightconfig(env)
      end
    end,
    force = true,
  })
end, { desc = "Save virtual environment" })

-- Toggle
local Toggle = require("helpers.toggle")
vim.keymap.set("n", "<leader>uf", Toggle.format, { desc = "Toggle format on save" })
vim.keymap.set("n", "<leader>uc", Toggle.conceal, { desc = "Toggle conceal" })
vim.keymap.set("n", "<leader>ud", Toggle.diagnostics, { desc = "Toggle diagnostics" })

vim.keymap.set("n", "<C-,>", function()
  vim.diagnostic.open_float(nil, { scope = "line" })
end, { silent = true, desc = "Show diagnostics" })
vim.keymap.set("n", "[,", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "],", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })

local M = {}

function M.lsp_on_attach(client, bufnr)
  local map = function(m, lhs, rhs, desc)
    vim.keymap.set(m, lhs, rhs, { remap = false, silent = true, buffer = bufnr, desc = desc })
  end

  if client.server_capabilities.hoverProvider then
    map("n", "K", vim.lsp.buf.hover, "Show information")
  end

  if client.server_capabilities.definitionProvider then
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  end

  if client.server_capabilities.declarationProvider then
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  end

  if client.server_capabilities.implementationProvider then
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  end

  if client.server_capabilities.typeDefinitionProvider then
    map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
  end

  if client.server_capabilities.referencesProvider then
    map("n", "gr", vim.lsp.buf.references, "Show references")
  end

  if client.server_capabilities.renameProvider then
    map("n", "<C-CR>", vim.lsp.buf.rename, "Rename symbol")
  end

  if client.server_capabilities.codeActionProvider then
    map("n", "<C-.>", vim.lsp.buf.code_action, "Code action")
  end
end

function M.null_ls_on_attach(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "<leader>F", function()
      require("helpers.format").format(client.id, bufnr, true, false)
    end, { remap = false, silent = true, buffer = bufnr, desc = "Format buffer" })
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("v", "gq", function()
      require("helpers.format").format(client.id, bufnr, true, false)
    end, { remap = false, silent = true, buffer = bufnr, desc = "Format selection" })
  end
end

return M
