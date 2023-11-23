-- https://github.com/nvim-lualine/lualine.nvim

local M = {}
function executeCommand(command)
  local handle = io.popen(command)
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    return result
  else
    return nil
  end
end

function getCurrentEnvironment()
  local pythonBin = executeCommand("which python")
  if pythonBin == nil or pythonBin == "" then
    pythonBin = executeCommand("which python3")
  end
  local icons = require "nvim-web-devicons"
  local py_icon, _ = icons.get_icon ".py"
  -- 提取环境名称
  local environmentName = ""
  if pythonBin == nil or pythonBin == "" then
    environmentName = "NoPython"
  elseif string.match(pythonBin, "conda") then
    local condaEnv = os.getenv("CONDA_DEFAULT_ENV")
    environmentName = "conda[" .. condaEnv .. "]"
  elseif string.match(pythonBin, "venv") then
    environmentName = "venv" .. os.getenv("VIRTUAL_ENV_PROMPT")
  else
    environmentName = pythonBin
  end
  return py_icon .. environmentName
end

local python_env = {
  function()
    if vim.bo.filetype == "python" then
      local currentEnv = getCurrentEnvironment()
      return currentEnv
    end
    return ""
  end,
  color = { fg = "#98be65" }
}

M.setup = function()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename', python_env },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
end


return M
