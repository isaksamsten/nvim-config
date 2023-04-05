local M = {}
local get_root = require("helpers").get_root

M.current_conda_env = nil

M.default_env = {
  PATH = vim.env.PATH,
  VIRTUAL_ENV = vim.env.VIRTUAL_ENV,
  PYTHONHOME = vim.env.PYTHONHOME,
}

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
function M.pyright_venv()
  if vim.b.pyrightconfig then
    local cache_mtime = vim.b.pyrightconfig_mtime
    if cache_mtime then
      local root = get_root({ "pyrightconfig.json" })
      if root then
        local path = vim.fn.simplify(root .. "/" .. "pyrightconfig.json")
        if path then
          local actual_mtime = vim.loop.fs_stat(path).mtime
          if actual_mtime and actual_mtime.sec == cache_mtime.sec then
            return vim.b.pyrightconfig
          end
        end
      end
    end
  end

  local root = get_root({ "pyrightconfig.json" })
  if root then
    local path = vim.fn.simplify(root .. "/" .. "pyrightconfig.json")
    if vim.loop.fs_stat(path) then
      local data = table.concat(vim.fn.readfile(path), "\n")
      local config = vim.json.decode(data)
      if config.venv and config.venvPath then
        local venv_path = vim.fn.simplify(config.venvPath .. "/" .. config.venv)
        local exe = vim.fn.simplify(venv_path .. "/bin/python")
        local conda_prefix = M.conda_envs().default_prefix
        local is_conda = string.match(venv_path, conda_prefix) ~= nil
        local type = "venv"
        if is_conda then
          type = "conda"
        end
        local stat = vim.loop.fs_stat(path)
        if stat then
          vim.b.pyrightconfig_mtime = stat.mtime
          vim.b.pyrightconfig = {
            exe = exe,
            path = venv_path,
            type = type,
            name = config.venv,
            version = python_version(exe),
          }
          return vim.b.pyrightconfig
        end
      end
    end
  end
  vim.b.pyrightconfig = false
  return nil
end

function M.write_pyrightconfig()
  local python = M.current_conda_env
  if python and python.type ~= "native" then
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

function M.conda_envs()
  if vim.fn.executable("conda") > 0 then
    local conda_envs = vim.fn.system({ "conda", "info", "--envs", "--json" })
    return vim.json.decode(conda_envs)
  end

  return nil
end

local function create_conda_env_from_env_path(env_path, conda_prefix)
  local exe = vim.fn.simplify(env_path .. "/bin/python")
  local name = vim.fs.basename(env_path)
  if env_path == conda_prefix then
    name = "base"
  elseif not string.find(env_path, conda_prefix) then
    name = env_path
  end
  return {
    exe = exe,
    path = env_path,
    type = "conda",
    name = name,
    version = python_version(exe),
  }
end

--- Set the conda environment to the selected_conda_path variable
function M.select_conda(callback)
  local conda = M.conda_envs()
  if conda then
    if M.pyright_venv() then
      vim.notify("Unable to select Conda. Virtual environment is configured in pyrightconfig.json")
    else
      vim.ui.select(conda.envs, { prompt = "Select conda environment" }, function(selected)
        if selected then
          M.current_conda_env = create_conda_env_from_env_path(selected, conda.conda_prefix)
          if callback then
            callback(M.current_conda_env)
          end
        else
          M.current_conda_env = nil
        end
      end)
    end
  else
    vim.notify("Unable to select Conda. Is conda installed?")
  end
end

--- @return nil|table The python path
function M.python()
  -- First, check if we have a pyrightconfig.json file with configured virtual environment
  local venv = M.pyright_venv()
  if venv then
    return venv
  end

  -- Then, check if we have manually selected a conda environment
  if M.current_conda_env then
    return M.current_conda_env
  else
    -- Then, check if we have activated a conda environment other than "base"
    local conda = M.current_conda_env
    if conda then
      M.current_conda_env = conda
    end

    -- Fall back to system python
    return M.current_conda_env or M.system()
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

--- Resets the environment variables set by set_env to the default values from when Vim was started.
local function reset_env()
  vim.env.PATH = M.default_env.PATH
  vim.env.PYTHONHOME = M.default_env.PYTHONHOME
  vim.env.VIRTUAL_ENV = M.default_env.VIRTUAL_ENV
end

--- Set the environment variables according to the selected virtual environment.
local function set_env(python)
  if python and python.type ~= "native" then
    reset_env()
    vim.env.PATH = vim.fn.simplify(python.path .. "/bin") .. ":" .. vim.env.PATH
    if python.type ~= "conda" then
      vim.env.virtual_env = python.path
    end
    vim.env.pythonhome = nil
  end
end

--- Activate the virtual environment specified in pyrightconfig or conda if there is no pyrightconfig.json
function M.activate(env)
  local venv = M.pyright_venv()
  if venv then
    if env then
      vim.notify("Activating virtual environment specified in pyrightconfig.json")
      return false
    end
    set_env(venv)
    return true
  else
    if not env then
      if M.current_conda_env then
        set_env(M.current_conda_env)
        return true
      end
    end
    if env then
      set_env(env)
      return true
    else
      vim.notify("No environment specified. No virtual environment is activated")
      return false
    end
  end
end

--- Reset the environment
function M.deactivate()
  reset_env()
end

--- @return nil|string command to activate the python environment
function M.activate_command()
  local env = M.python()

  if env then
    if env.type == "venv" then
      return "source " .. vim.fn.simplify(env.path .. "/bin/activate")
    elseif env.type == "conda" then
      return "conda activate " .. env.name
    else
      return nil
    end
  end

  return nil
end

return M
