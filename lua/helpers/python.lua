local M = {}
local get_root = require("helpers").get_root

M.current_conda_env = nil
M.current_pyright = nil
M.is_activated = false
M.default_env = nil

---@return string - the version the python executable
local function python_version(executable)
  local version = vim.fn.system({ executable, "--version" })
  return string.sub(version, 8, -2)
end

---@return table|nil - The system global 'native' python executable
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
---@return table|nil - The python virtualenv specified in pyrightconfig.json
function M.pyright_venv()
  -- Use the cached virtual environment if we already found it
  if M.current_pyright then
    local cache_mtime = M.current_pyright.mtime
    if cache_mtime then
      local root = get_root({ "pyrightconfig.json" })
      if root then
        local path = vim.loop.fs_stat(vim.fn.simplify(root .. "/" .. "pyrightconfig.json"))
        if path then
          -- Also, check if the pyrightconfig.json file have changed since last
          local actual_mtime = path.mtime
          if actual_mtime and actual_mtime.sec == cache_mtime.sec then
            return M.current_pyright.env
          end
        end
      end
    end
  end

  -- If not, we try to detect a virtual environment from a pyrightconfig
  local root = get_root({ "pyrightconfig.json" })
  if root then
    local path = vim.fn.simplify(root .. "/" .. "pyrightconfig.json")
    if vim.loop.fs_stat(path) then
      local data = table.concat(vim.fn.readfile(path), "\n")
      local config = vim.json.decode(data)
      if config.venv and config.venvPath then
        -- Crudly check if the specified virtual environment is a Conda environment
        local conda_prefix = M.conda_envs().default_prefix
        local is_conda = string.match(config.venvPath, conda_prefix) ~= nil
        local venv_path = vim.fn.simplify(config.venvPath .. "/" .. config.venv)
        local exe = vim.fn.simplify(venv_path .. "/bin/python")
        local type = "venv"
        if is_conda then
          type = "conda"
        end

        -- Check that the env has a python executable
        local config_mtime = vim.loop.fs_stat(path).mtime
        if vim.loop.fs_stat(exe) then
          M.current_pyright = {
            mtime = config_mtime,
            env = {
              exe = exe,
              path = venv_path,
              type = type,
              name = config.venv,
              version = python_version(exe),
            },
          }
          return M.current_pyright.env
        else
          vim.notify("Could not find the virtual environment specified in pyrightconfig")
          M.current_pyright = { env = nil, mtime = config_mtime }
        end
      end
    end
  end

  -- We don't have a pyrightconfig, or it is incorrectly specified
  return nil
end

function M.write_pyrightconfig(venv)
  if venv and venv.type ~= "native" then
    local root = get_root({ "setup.py", "pyproject.toml" })
    local pyrightconfig = vim.fn.simplify(root .. "/" .. "pyrightconfig.json")
    if root then
      local config = {}
      if vim.loop.fs_stat(pyrightconfig) then
        config = vim.json.decode(table.concat(vim.fn.readfile(pyrightconfig), "\n"))
      end
      config.venvPath = vim.fs.dirname(venv.path)
      config.venv = venv.name

      config = vim.json.encode(config)
      vim.fn.writefile({ config }, pyrightconfig)
      M.current_pyright = nil
      return true
    end
  end
  return false
end

function M.conda_envs()
  if vim.fn.executable("conda") > 0 then
    local conda_envs = vim.fn.system({ "conda", "info", "--envs", "--json" })
    return vim.json.decode(conda_envs)
  end

  return nil
end

local function create_conda_env_from_env_path(env_path)
  local exe = vim.fn.simplify(env_path .. "/bin/python")

  if vim.loop.fs_stat(exe) then
    local name = vim.fs.basename(env_path)
    return {
      exe = exe,
      path = env_path,
      type = "conda",
      name = name,
      version = python_version(exe),
    }
  else
    return nil
  end
end

--- Set the conda environment to the selected_conda_path variable
function M.select_conda(opts)
  opts = opts or {}
  local conda = M.conda_envs()
  if conda then
    local venv = M.pyright_venv()
    if venv and not opts.force then
      vim.notify("Unable to select Conda. Virtual environment is configured in pyrightconfig.json")
      if opts.callback then
        opts.callback()
      end
    else
      local envs = {}
      for _, env in ipairs(conda.envs) do
        -- Only include Global conda environments
        if env ~= conda.conda_prefix and string.match(env, conda.conda_prefix) then
          table.insert(envs, env)
        end
      end

      vim.ui.select(envs, { prompt = "Select conda environment" }, function(selected)
        if selected then
          M.current_conda_env = create_conda_env_from_env_path(selected)
          if opts.callback then
            opts.callback(M.current_conda_env)
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

--- Returns the current Python environment
---
--- 1) Any virtual environment specified in pyrightconfig.json
--- 2) Any conda environment specified with the variable vim.g.conda_environment
--- 3) A selected conda environment
--- 4) The system python installation
---
--- @return nil|table - The python path
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
    if vim.g.conda_environment then
      local conda_prefix = M.conda_envs().conda_prefix
      local conda_env = vim.fn.simplify(conda_prefix .. "/envs/" .. vim.g.conda_environment)
      M.current_conda_env = create_conda_env_from_env_path(conda_env)
    end

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
  if M.default_env ~= nil then
    vim.env.PATH = M.default_env.PATH
    vim.env.PYTHONHOME = M.default_env.PYTHONHOME
    vim.env.VIRTUAL_ENV = M.default_env.VIRTUAL_ENV
    vim.env.CONDA_DEFAULT_ENV = M.default_env.CONDA_DEFAULT_ENV
    vim.env.CONDA_PREFIX = M.default_env.CONDA_PREFIX
  end
  M.is_activated = false
end

--- Set the environment variables according to the selected virtual environment.
local function set_env(python)
  -- save the default environment
  if M.default_env == nil then
    M.default_env = {
      PATH = vim.env.PATH,
      VIRTUAL_ENV = vim.env.VIRTUAL_ENV,
      PYTHONHOME = vim.env.PYTHONHOME,
      CONDA_DEFAULT_ENV = vim.env.CONDA_DEFAULT_ENV,
      CONDA_PREFIX = vim.env.CONDA_PREFIX,
    }
  end

  if python and python.type ~= "native" then
    reset_env()
    vim.env.PATH = vim.fn.simplify(python.path .. "/bin") .. ":" .. vim.env.PATH
    if python.type == "venv" then
      vim.env.VIRTUAL_ENV = python.path
    elseif python.type == "conda" then
      vim.env.CONDA_PREFIX = python.path
      vim.env.CONDA_DEFAULT_ENV = python.name
    end
    vim.env.PYTHONHOME = nil
    M.is_activated = true
  end
end

--- Activate the virtual environment specified in pyrightconfig or conda if there is no pyrightconfig.json
--- @return boolean - true if the LSP needs to be restarted; false otherwise
function M.activate(env)
  local venv = M.python()
  if not env and venv and venv.type ~= "native" then
    set_env(venv)
    return venv.type == "venv"
  else
    if env then
      set_env(env)
      return true
    else
      return false
    end
  end
end

--- Reset the environment
function M.deactivate()
  reset_env()
end

--- @return nil|string - command to activate the python environment
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
