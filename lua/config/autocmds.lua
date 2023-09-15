vim.api.nvim_create_autocmd("TermOpen term://*", {
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Search" })
  end,
})

-- Activate the current virtual environment. Typically loaded
-- from the pyrightconfig.json file before entering the buffer,
-- which means it is activated before pyright.
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.py",
  callback = function()
    local Python = require("helpers.python")
    if not Python.is_activated then
      Python.activate()
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("AutoCloseWithQ", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SetWrap", { clear = true }),
  pattern = { "markdown", "rst", "latex", "txt" },
  command = "setlocal wrap",
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  callback = function(args)
    local ok, _ = pcall(vim.api.nvim_buf_get_var, args.buf, "is_format_active")
    if not ok then
      local root = require("helpers").get_root({ ".git" })
      local file = vim.fn.simplify(root .. "/.disable-format-on-save")
      local format_on_save = vim.loop.fs_stat(file) == nil
      vim.fn.setbufvar(args.buf, "is_format_active", format_on_save)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if require("helpers.toggle").format_active() then
      require("conform").format({ bufnr = args.buf })
    end
  end,
})
vim.cmd([[
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber 
]])
