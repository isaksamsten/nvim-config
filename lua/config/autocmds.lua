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
    vim.keymap.set("n", "q", function()
      if #vim.api.nvim_list_wins() > 1 then
        vim.cmd("close")
      end
    end, { buffer = event.buf, silent = true })
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

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("json_conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex" },
  command = "setlocal wrap breakindent conceallevel=0",
})

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    local ok, ibl = pcall(require, "ibl")
    if ok then
      if vim.opt.diff:get() then
        ibl.update({ enabled = false })
      else
        ibl.update({ enabled = true })
      end
    end
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "qf",
--   callback = function()
--     print("qt")
--   end,
-- })
