local M = {}
local get_root = require("helpers").get_root

M.selected_conda = nil

local function python_version(executable)
  local version = vim.fn.system({ executable, "--version" })
  return string.sub(version, 8, -2)
end

function M.system()
  local where = vim.fn.exepath("python")
  if where == "" then
    where = vim.fn.exepath("python3")
  end
  if where ~= "" then
    return {
      exe = where,
      path = vim.fs.dirname(where),
      type = "native",
      name = "system",
      version = python_version(where),
    }
  end
  return nil
end

--- Detect the current virtual environment from pyrightconfig.json
function M.venv()
  local root = get_root({ "pyrightconfig.json" })
  if root then
    local path = vim.fn.simplify(root .. "/" .. "pyrightconfig.json")
    if vim.loop.fs_stat(path) then
      local data = table.concat(vim.fn.readfile(path), "\n")
      local config = vim.json.decode(data)
      if config.venv and config.venvPath then
        path = vim.fn.simplify(config.venvPath .. "/" .. config.venv)
        local exe = vim.fn.simplify(path .. "/bin/python")

        if vim.loop.fs_stat(exe) then
          return {
            exe = exe,
            path = path,
            type = "venv",
            name = config.venv,
            version = python_version(exe),
          }
        end
      end
    end
  end
  return nil
end

function M.write_pyrightconfig()
  local python = M.python(false)
  if python.type ~= "native" then
    local root = get_root({ "setup.py", "pyproject.toml" })
    local pyrightconfig = vim.fn.simplify(root .. "/" .. "pyrightconfig.json")
    if root then
      local config = {}
      if vim.loop.fs_stat(pyrightconfig) then
        config = vim.json.decode(table.concat(vim.fn.readfile(pyrightconfig), "\n"))
      end
      config.venvPath = vim.fs.dirname(python.path)
      config.venv = python.name

      config = vim.json.encode(config)
      vim.fn.writefile({ config }, pyrightconfig)
    end
  end
end

function M.conda_list_envs()
  if vim.fn.executable("conda") > 0 then
    local conda_envs = vim.fn.system({ "conda", "info", "--envs", "--json" })
    return vim.json.decode(conda_envs)
  end

  return nil
end

function M.conda()
  if M.selected_conda then
    return M.selected_conda
  end

  local conda = M.conda_list_envs()
  if conda and conda.active_prefix_name ~= vim.NIL then
    if conda.active_prefix_name ~= "base" then
      local exe = vim.fn.simplify(conda.active_prefix .. "/bin/python")
      return {
        exe = exe,
        path = conda.active_prefix,
        type = "conda",
        name = conda.active_prefix_name,
        version = python_version(exe),
      }
    end
  end

  return nil
end

--- Set the conda environment to the selected_conda_path variable
function M.select_conda()
  local conda = M.conda_list_envs()
  if conda then
    return vim.ui.select(conda.envs, { prompt = "Select conda environment" }, function(selected)
      if selected then
        local exe = vim.fn.simplify(selected .. "/bin/python")
        local name = vim.fs.basename(selected)
        if selected == conda.conda_prefix then
          name = "base"
        elseif not string.find(selected, conda.conda_prefix) then
          name = selected
        end
        M.selected_conda = {
          exe = exe,
          path = selected,
          type = "conda",
          name = name,
          version = python_version(exe),
        }
      else
        M.selected_conda = nil
      end
    end)
  end
end

--- @return nil|table The python path
function M.python(prefer_venv)
  if prefer_venv == nil then
    prefer_venv = true
  end

  -- First, check if we have a pyrightconfig.json file with configured virtual environment
  local venv = M.venv()
  if venv and prefer_venv then
    return venv
  end

  -- Then, check if we have manually selected a conda environment
  if M.selected_conda then
    return M.selected_conda
  else
    -- If we have pyrightconfig but don't always want it, we want it now
    if venv then
      return venv
    end

    -- Then, check if we have activated a conda environment other than "base"
    local conda = M.conda()
    if conda then
      M.selected_conda = conda
    end

    -- Fall back to system python
    return M.selected_conda or M.system()
  end
end

--- @return nil|string path to a python executable
function M.executable()
  local base_path = M.python()

  if base_path then
    return base_path.exe
  end

  return nil
end

--- @return nil|string command to activate the python environment
function M.activate_command()
  local base_path = M.python()

  if base_path and base_path.type ~= "native" then
    return "source " .. vim.fn.simplify(base_path.path .. "/bin/activate")
  end

  return nil
end

return M
