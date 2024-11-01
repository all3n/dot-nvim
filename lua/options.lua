-- @author: all3n
-- basic options for neovim (from origin vim opts)

-- options reference: https://neovim.io/doc/user/options.html
-- set xxx  -> vim.opt.xxx = true
-- set noxxx  -> vim.opt.xxx = false
-- vim.o.xxx -> (lua) vim.opt.xxx

local M = {}
_G.all3nvim.opt = {}

M.load_headless_options = function()
  vim.opt.shortmess = ""   -- try to prevent echom from cutting messages off or prompting
  vim.opt.more = false     -- don't pause listing when screen is filled
  vim.opt.cmdheight = 9999 -- helps avoiding |hit-enter| prompts.
  vim.opt.columns = 9999   -- set the widest screen possible
  vim.opt.swapfile = false -- don't use a swap file
end



M.load_default_options = function()
  -- cursor line
  vim.opt.cursorline = true
  vim.opt.cursorcolumn = true

  -- vim.o.wildignore = '*.o,*.a,__pycache__'
  vim.opt.wildignore = { '*.o', '*.a', '__pycache__' }
  -- support clipboard
  vim.opt.clipboard = 'unnamedplus'

  -- show space/tab use chars
  vim.opt.listchars = { space = '_', tab = '>~' }
  -- backup
  vim.opt.backup = false
  -- cmd cmdheight
  vim.opt.cmdheight = 1


  -- vim.opt.completeopt = {'menu', 'preview'}
  -- vim.opt.completeopt = { "menuone", "noselect" }

  -- file encoding
  vim.opt.fileencodings = {'utf-8', 'ucs-bom','cp936','gb18030','latin1'}

  -- foldmethod
  vim.opt.foldmethod = "manual"

  -- highlight search
  vim.opt.hlsearch = true

  -- mouse support all(a) mode
  vim.opt.mouse = "a"

  -- tab
  vim.opt.tabstop = 2      -- insert 2 space for a tab
  vim.opt.shiftwidth = 2   -- the number of spaces inserted for each indendation
  vim.opt.expandtab = true -- convert tab to space

  -- display lines as one long line
  vim.opt.wrap = false


  -- signed column
  vim.opt.signcolumn = "yes"
  -- number column
  vim.opt.number = true
  vim.opt.numberwidth = 4

  vim.opt.title = true


  vim.opt.swapfile = false

  vim.opt.smartcase = true
  vim.opt.ignorecase = true -- search ignore case

  -- bufferline req
  vim.opt.termguicolors = true
  -- vim.opt.verbose = 1
  -- vim.opt.verbosefile = vim.fn.stdpath("data") .. "/" .. "nvim.log"

  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
end




M.load_defaults = function()
  if #vim.api.nvim_list_uis() == 0 then
    M.load_headless_options()
    return
  end
  M.load_default_options()
end


return M
