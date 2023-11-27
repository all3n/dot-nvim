-- https://github.com/nvim-lualine/lualine.nvim

local M = {}
local lsp_env = {
  function()
    return _G.all3nvim.env or "-"
  end,
  color = { fg = "#98be65" }
}


local REMOTE_ICON = '📡'
local function remote_statusline()
  local ok, plugin = pcall(require, 'distant')
  if not ok or not plugin:is_initialized() or not plugin.buf.has_data() then
    return ''
  end
  local destination = assert(plugin:client_destination(plugin.buf.client_id()))
  return ('%s %s'):format(REMOTE_ICON, destination.host)
end

local project_name = {
  function()
    local project_name = require("utils").get_project_name()
    if project_name then
      return '[' .. project_name .. ']'
    else
      return '-'
    end
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
      lualine_c = { 'filename', lsp_env, remote_statusline },
      lualine_x = { project_name, 'encoding', 'fileformat', 'filetype' },
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
