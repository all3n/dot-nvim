-- https://github.com/L3MON4D3/LuaSnip
require("luasnip.loaders.from_lua").lazy_load()
local paths = {}
local custom_snippets = vim.fn.stdpath("config") .. "/snippets"
paths[#paths + 1] = custom_snippets
paths[#paths + 1] = vim.fn.stdpath("data") .. "/lazy/friendly-snippets"

require("luasnip/loaders/from_vscode").lazy_load({
  paths = paths
})
require("luasnip.loaders.from_snipmate").lazy_load()

