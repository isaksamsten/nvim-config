local M = {}

M.root_patterns = { ".git" }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
function M.get_root(root_patterns)
  root_patterns = root_patterns or M.root_patterns
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil

  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)

  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()

    root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end

  return root
end

function M.is_remote()
  local wez = os.getenv("WEZTERM_EXECUTABLE")
  return os.getenv("SSH_CLIENT") ~= nil or (wez ~= nil and string.match(wez, "wezterm%-mux%-server") ~= nil)
end

function M.telescope_theme(theme, opts)
  opts = opts or {}
  if theme == "cursor" then
    return vim.tbl_extend("keep", {
      previewer = true,
      preview_title = "",
      sorting_strategy = "ascending",
      layout_strategy = "cursor",
      layout_config = {
        cursor = {
          preview_width = 0.5,
          width = 0.5,
          height = 15,
        },
      },
    }, opts)
  else
    return {}
  end
end

-- From LazyVim
M.skip_foldexpr = {}
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then
    return "0"
  end

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

M.pick_buffers = function()
  local buffers_output = vim.api.nvim_exec("buffers", true)
  local cur_buf_id = vim.api.nvim_get_current_buf()
  local items = {}
  for _, l in ipairs(vim.split(buffers_output, "\n")) do
    local buf_str, name = l:match("^%s*%d+"), l:match('"(.*)"')
    local buf_id = tonumber(buf_str)
    local item = { text = name, bufnr = buf_id }
    if buf_id ~= cur_buf_id then
      table.insert(items, item)
    end
  end
  table.sort(items, function(a, b)
    return vim.fn.getbufinfo(a.bufnr)[1].lastused > vim.fn.getbufinfo(b.bufnr)[1].lastused
  end)

  -- local default_opts = { source = { name = "Buffers", show = true } }
  local MiniPick = require("mini.pick")
  local show_with_icons = function(buf_id, items, query)
    MiniPick.default_show(buf_id, items, query, { show_icons = true })
  end

  return MiniPick.start({ source = { name = "Buffers", show = show_with_icons, items = items } })
end
return M
