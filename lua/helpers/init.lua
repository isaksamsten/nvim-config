local M = {}

M.root_patterns = { ".git" }

function M.extend_hl(name, def)
  local current_def = vim.api.nvim_get_hl_by_name(name, true)
  local new_def = vim.tbl_extend("force", {}, current_def, def)

  vim.api.nvim_set_hl(0, name, new_def)
end

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
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
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

return M
