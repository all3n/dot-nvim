_G.all3nvim = {
  colorscheme = "everforest",
  plugins = {
    tabnine = 1
  }
}
-- load vim basic classic options
require("options").load_defaults()
-- load plugins
require("plugins")
local commands = require("commands")
commands.load(commands.defaults)
require("keymaps")
vim.cmd.colorscheme(all3nvim.colorscheme)
