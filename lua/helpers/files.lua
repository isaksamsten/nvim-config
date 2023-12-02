local M = {}

local show_dotfiles = true
local show_gitignore = false

M.filter_show_default = function(entry)
  return entry.name ~= ".DS_Store" and entry.name ~= ".git" and entry.name ~= ".direnv"
end

M.filter_hide_dotfile = function(entry)
  return not vim.startswith(entry.name, ".")
end

M.toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and M.filter_show_default or M.filter_hide_dotfile
  require("mini.files").refresh({ content = { filter = new_filter } })
end

M.toggle_gitignore = function()
  show_gitignore = not show_gitignore
  local new_filter_sort = show_gitignore and require("mini.files").default_sort or M.sort_filter_gitignore
  require("mini.files").refresh({ content = { sort = new_filter_sort } })
end

-- https://github.com/mrjones2014/dotfiles/blob/31f7988420e5418925022c524de04934e02a427c/nvim/lua/my/configure/mini_files.lua#L48C14-L79C6
M.sort_filter_gitignore = function(entries)
  local all_paths = table.concat(
    vim.tbl_map(function(entry)
      return entry.path
    end, entries),
    "\n"
  )
  local output_lines = {}
  local job_id = vim.fn.jobstart({ "git", "check-ignore", "--stdin" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      output_lines = data
    end,
  })

  -- command failed to run
  if job_id < 1 then
    return entries
  end

  -- send paths via STDIN
  vim.fn.chansend(job_id, all_paths)
  vim.fn.chanclose(job_id, "stdin")
  vim.fn.jobwait({ job_id })
  return require("mini.files").default_sort(vim.tbl_filter(function(entry)
    return not vim.tbl_contains(output_lines, entry.path)
  end, entries))
end

return M
