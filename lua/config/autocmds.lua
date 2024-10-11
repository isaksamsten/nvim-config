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

-- if vim.g.disable_iterm2_integration == nil and vim.env.ITERM_PROFILE ~= nil then
--   local function set_iterm2_current_filename(string)
--     io.write(("\x1b]1337;SetUserVar=nvim_current_file=%s\x07]"):format(vim.base64.encode(string)))
--   end
--
--   vim.api.nvim_create_autocmd("BufEnter", {
--     group = vim.api.nvim_create_augroup("iterm2", {}),
--     pattern = "*",
--     callback = function(args)
--       local bufname = vim.fn.bufname(args.buf)
--       local filename = vim.fn.fnamemodify(bufname, ":p:~:.")
--       local extension = vim.fn.fnamemodify(bufname, ":t:e")
--       local icon, icon_hl = require("nvim-web-devicons").get_icon(bufname, extension)
--       if not icon or icon == "nil" then
--         icon = ""
--       end
--       if filename ~= "" then
--         set_iterm2_current_filename(icon .. " " .. filename)
--       else
--         set_iterm2_current_filename(" ")
--       end
--     end,
--   })
--
--   vim.api.nvim_create_autocmd("VimLeavePre", {
--     group = vim.api.nvim_create_augroup("iterm2-leave", {}),
--     callback = function()
--       set_iterm2_current_filename("")
--     end,
--   })
-- end
--
-- local CursorBlend = {}

-- CursorBlend.ft = { "qf", "neotest-summary" }
-- CursorBlend.hidden = false

-- function CursorBlend.hide()
--   local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
--   hl.blend = 100
--   vim.api.nvim_set_hl(0, "Cursor", hl)
--   vim.opt.guicursor:append("a:Cursor/lCursor")
--   CursorBlend.hidden = true
-- end

-- function CursorBlend.show()
--   local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
--   hl.blend = nil
--   vim.api.nvim_set_hl(0, "Cursor", hl)
--   vim.opt.guicursor:remove("a:Cursor/lCursor")
--   CursorBlend.hidden = false
-- end

-- function CursorBlend.toggle(ft)
--   if not CursorBlend.hidden and vim.tbl_contains(CursorBlend.ft, ft) then
--     CursorBlend.hide()
--   elseif not vim.tbl_contains(CursorBlend.ft, ft) then
--     CursorBlend.show()
--   end
-- end

-- vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
--   group = vim.api.nvim_create_augroup("BlendCursor", { clear = true }),
--   nested = true,
--   pattern = "*",
--   callback = function(args)
--     CursorBlend.toggle(vim.bo[args.buf].filetype)
--   end,
-- })
-- vim.api.nvim_create_autocmd({ "CmdwinEnter", "CmdlineEnter" }, {
--   group = vim.api.nvim_create_augroup("BlendCursorCmd", { clear = true }),
--   nested = true,
--   pattern = "*",
--   callback = function(args)
--     CursorBlend.show()
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "CmdwinLeave", "CmdlineLeave" }, {
--   group = vim.api.nvim_create_augroup("BlendCursorCmdLeave", { clear = true }),
--   nested = true,
--   pattern = "*",
--   callback = function(args)
--     CursorBlend.toggle(vim.bo[args.buf].filetype)
--   end,
-- })

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

-- local ignore_filetypes = { "neo-tree", "minifiles", "alpha", "neotest-summary", "TelescopePrompt", "gf" }
-- if not vim.g.vscode then
--   vim.api.nvim_create_autocmd("InsertEnter", {
--     pattern = "*",
--     callback = function(args)
--       if not vim.tbl_contains(ignore_filetypes, vim.bo[args.buf].filetype) then
--         vim.cmd(":setlocal norelativenumber")
--       end
--     end,
--   })
--   vim.api.nvim_create_autocmd("InsertLeave", {
--     pattern = "*",
--     callback = function(args)
--       if not vim.tbl_contains(ignore_filetypes, vim.bo[args.buf].filetype) then
--         vim.cmd(":setlocal relativenumber")
--       end
--     end,
--   })
-- end

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
