local null_ls = require("null-ls")
null_ls.register({ null_ls.builtins.formatting.autopep8 })

local utils = require("utils")
local commands = require("commands")
local project_config = require("project_config")
local ui_widgets = require("ui_widgets")
local dap = require('dap')
local python = _G.all3nvim.python
local def_env = python.default
local p_config = project_config.get()
if p_config and p_config.python ~= nil then
  python = vim.tbl_extend("force", python, p_config.python)
end

local project_python_path = python["PYTHONPATH"]
local project_dir = utils.get_project_root(nil)

-- local python_commands = {
--   {
--     name = "AddPythonPath",
--     fn = function()
--
--     end
--   }
-- }
-- commands.load(python_commands)




-- local project_python_dir = join_paths(project_dir, "python")
if project_python_path ~= nil then
  if vim.env["PYTHONPATH"] == nil then
    vim.env["PYTHONPATH"] = project_python_path
  else
    vim.env["PYTHONPATH"] = vim.env["PYTHONPATH"] .. ":" .. project_python_path
  end
end

for k, v in pairs(python.envs) do
  python.envs[k] = vim.api.nvim_call_function("expand", { v })
end

-- python.bin = nil
local envs = {}

local function getCurrentEnvironment(env_python_bin)
  local pythonBin = env_python_bin or utils.execute_command("which python")
  local python_version = nil
  if pythonBin == nil or pythonBin == "" then
    pythonBin = utils.execute_command("which python3")
  end
  if pythonBin ~= nil then
    python_version = utils.execute_command(pythonBin .. " --version")
  end
  _G.all3nvim.python.bin = pythonBin
  vim.g.python3_host_prog = pythonBin
  local icons = require "nvim-web-devicons"
  local py_icon, _ = icons.get_icon ".py"
  local environmentName = nil
  if pythonBin == nil or pythonBin == "" then
    environmentName = nil
  elseif string.match(pythonBin, "conda") then
    local condaEnv = os.getenv("CONDA_DEFAULT_ENV")
    environmentName = "conda[" .. condaEnv .. "]"
  elseif string.match(pythonBin, "venv") then
    environmentName = "venv" .. os.getenv("VIRTUAL_ENV_PROMPT")
  else
    environmentName = pythonBin
  end
  if environmentName == nil then
    return "-"
  else
    return py_icon .. environmentName .. ":" .. python_version
  end
end


if python.envs ~= nil then
  for _, env in pairs(python.envs) do
    table.insert(envs, env)
  end
  local change_env = function(envs_)
    local picker_fn = ui_widgets.build_picker("change python environment", envs_, function(c)
      local env_python_bin = c
      _G.all3nvim.env = getCurrentEnvironment(env_python_bin)
      _G.all3nvim.exec_env = "PYTHON=" .. _G.all3nvim.python.bin
      project_config.save({
        python = {
          bin = _G.all3nvim.python.bin
        }
      })
    end)
    picker_fn()
  end
  utils.register_envs(envs, change_env)
end


if _G.all3nvim.env == nil then
  _G.all3nvim.env = getCurrentEnvironment(python.bin or python.envs[def_env])
end
if _G.all3nvim.python.bin ~= nil then
  _G.all3nvim.exec_env = "PYTHON=" .. _G.all3nvim.python.bin
end

require("dap-python").setup("python", {})
table.insert(dap.configurations.python, {
  type = "python",
  request = "attach",
  connect = {
    port = 5678,
    host = "127.0.0.1",
  },
  mode = "remote",
  name = "Container Attach Debug",
  cwd = vim.fn.getcwd(),
  pathMappings = {
    {
      localRoot = function()
        return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
      end,
      remoteRoot = function()
        return vim.fn.input("Container code folder > ", "/", "file")
      end,
    },
  },
})
