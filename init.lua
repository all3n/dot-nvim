_G.all3nvim = {
  colorscheme = "everforest",
  plugins = {
    tabnine = false
  },
  change_env = nil,
  exec_env = ""
}
local utils = require("utils")
local config_json = vim.fn.stdpath("config") .. "/config.json"

local project_dir = utils.get_project_root(nil) or vim.fn.expand('%:p:h')
local project_json = project_dir .. "/project_config.json"

if vim.fn.filereadable(config_json) ~= 1 then
  local config_tmp_json = vim.fn.stdpath("config") .. "/configs/config.template.json"
  -- copy configs/config.template.json to config.json
  utils.fs_copy(config_tmp_json, config_json)
end

local ok, data = utils.json_decode(config_json)
if ok then
  _G.all3nvim = vim.tbl_extend("force", _G.all3nvim, data)
else
  vim.notify(data)
end

if vim.fn.filereadable(project_json) == 1 then
  local p_ok, p_data = utils.json_decode(project_json)
  if p_ok then
    _G.all3nvim = vim.tbl_extend("force", _G.all3nvim, p_data)
  else
    vim.notify(p_data)
  end
end
-- load vim basic classic options
require("options").load_defaults()
-- load plugins
require("plugins")
local commands = require("commands")
commands.load(commands.defaults)
require("keymaps")
vim.cmd.colorscheme(all3nvim.colorscheme)
