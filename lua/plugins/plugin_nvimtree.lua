local M = {}
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
M.setup = function()
  require("nvim-tree").setup({
    sort = {
      sorter = "case_sensitive",
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true
    },
    filesystem_watchers = {
      enable = false
    }
  })
end
return M
