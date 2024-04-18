if vim.g.vscode then
  return
end

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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SetNoNumber", { clear = true }),
  pattern = { "qf" },
  command = "setlocal norelativenumber nonumber nospell",
})

local blend_cursor = { "qf", "neotest-summary" }
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("BlendCursor", { clear = true }),
  nested = true,
  pattern = "*",
  callback = function(args)
    local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
    if vim.tbl_contains(blend_cursor, vim.bo[args.buf].filetype) then
      hl.blend = 100
      vim.api.nvim_set_hl(0, "Cursor", hl)
      vim.opt.guicursor:append("a:Cursor/lCursor")
    elseif hl.blend == 100 then
      hl.blend = nil
      vim.api.nvim_set_hl(0, "Cursor", hl)
      vim.opt.guicursor:remove("a:Cursor/lCursor")
    end
  end,
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

local ignore_filetypes = { "neo-tree", "minifiles", "alpha", "neotest-summary", "TelescopePrompt", "gf" }
if not vim.g.vscode then
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function(args)
      if not vim.tbl_contains(ignore_filetypes, vim.bo[args.buf].filetype) then
        vim.cmd(":setlocal norelativenumber")
      end
    end,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function(args)
      if not vim.tbl_contains(ignore_filetypes, vim.bo[args.buf].filetype) then
        vim.cmd(":setlocal relativenumber")
      end
    end,
  })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "<ESC>", function()
      require("mini.files").close()
    end, { buffer = buf_id })
    vim.keymap.set("n", "g.", require("helpers.files").toggle_dotfiles, { buffer = buf_id })
    vim.keymap.set("n", "gi", require("helpers.files").toggle_gitignore, { buffer = buf_id })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.md", "*.tex" },
  command = "setlocal wrap breakindent conceallevel=0",
})
