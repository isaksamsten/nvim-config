-- vim.keymap.set("n", "<Left>", "<C-w>h", { desc = "Go to left window" })
-- vim.keymap.set("n", "<Right>", "<C-w>l", { desc = "Go to right window" })
-- vim.keymap.set("n", "<Down>", "<C-w>j", { desc = "Go to lower window" })
-- vim.keymap.set("n", "<Up>", "<C-w>k", { desc = "Go to upper window" })

-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

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

vim.keymap.set({ "n", "v" }, "<leader>tn", "<Esc><Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set({ "n", "v" }, "<leader>tc", "<Esc><Cmd>tabclose<CR>", { desc = "Close tab" })

vim.keymap.set({ "n" }, "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
vim.keymap.set({ "n" }, "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set({ "n" }, "]Q", "<cmd>clast<cr>", { desc = "Last quickfix" })
vim.keymap.set({ "n" }, "[Q", "<cmd>cfirst<cr>", { desc = "First quickfix" })

local Python = require("helpers.python")
vim.keymap.set("n", "<leader>aA", function()
  Python.select_conda({
    callback = function(env)
      if Python.activate(env) then
        vim.cmd("LspRestart<CR>")
      end
    end,
  })
end, { desc = "Select Conda environment", silent = false })

vim.keymap.set("n", "<leader>aa", function()
  Python.activate()
end, { desc = "Activate Python environment", silent = false })

vim.keymap.set("n", "<leader>as", function()
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

vim.keymap.set("n", "g,", function()
  vim.diagnostic.open_float(nil, { scope = "line" })
end, { silent = true, desc = "Show diagnostics" })
vim.keymap.set("n", "[,", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "],", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })

local M = {}

function M.lsp_on_attach(client, bufnr)
  local telescope_ok, builtin = pcall(require, "telescope.builtin")
  local map = function(m, lhs, rhs, desc)
    vim.keymap.set(m, lhs, rhs, { remap = false, silent = true, buffer = bufnr, desc = desc })
  end

  if client.server_capabilities.hoverProvider then
    map({ "n", "v" }, "K", vim.lsp.buf.hover, "Show information")
  end

  if client.server_capabilities.definitionProvider then
    local definitionProvider = vim.lsp.buf.definition
    if telescope_ok then
      definitionProvider = function()
        builtin.lsp_definitions(require("helpers").telescope_theme("cursor", { prompt_title = "Definition" }))
      end
    end
    map("n", "gd", definitionProvider, "Go to definition")
  end

  if client.server_capabilities.declarationProvider then
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  end

  if client.server_capabilities.implementationProvider then
    local implementationProvider = vim.lsp.buf.implementation
    if telescope_ok then
      implementationProvider = function()
        builtin.lsp_implementations(require("helpers").telescope_theme("cursor", { prompt_title = "Implementation" }))
      end
    end
    map("n", "gi", implementationProvider, "Go to implementation")
  end

  if client.server_capabilities.typeDefinitionProvider then
    local typeDefinitionProvider = vim.lsp.buf.type_definition
    if telescope_ok then
      typeDefinitionProvider = function()
        builtin.lsp_type_definitions(require("helpers").telescope_theme("cursor", { prompt_title = "Type definition" }))
      end
    end
    map("n", "go", typeDefinitionProvider, "Go to type definition")
  end

  if client.server_capabilities.referencesProvider then
    local referencesProvider = vim.lsp.buf.references
    if telescope_ok then
      referencesProvider = function()
        builtin.lsp_references(
          require("helpers").telescope_theme(
            "cursor",
            { prompt_title = "References", include_declaration = false, show_line = false, jump_type = "split" }
          )
        )
      end
    end
    map("n", "gr", referencesProvider, "Show references")
  end

  if client.server_capabilities.renameProvider then
    map("n", "<CR>", vim.lsp.buf.rename, "Rename symbol")
  end

  if client.server_capabilities.codeActionProvider then
    map({ "n", "v" }, "g.", vim.lsp.buf.code_action, "Code action")
  end
end

-- function M.null_ls_on_attach(client, bufnr)
--   if client.server_capabilities.documentFormattingProvider then
--     vim.keymap.set("n", "<leader>F", function()
--       require("helpers.format").format(client.id, bufnr, true, false)
--     end, { remap = false, silent = true, buffer = bufnr, desc = "Format buffer" })
--   end
--
--   if client.server_capabilities.documentRangeFormattingProvider then
--     vim.keymap.set("v", "gq", function()
--       require("helpers.format").format(client.id, bufnr, true, false)
--     end, { remap = false, silent = true, buffer = bufnr, desc = "Format selection" })
--   end
-- end

return M
