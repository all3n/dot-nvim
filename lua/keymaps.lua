-- keymap custom
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- normal mode buffer jumper next/previous
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
-- better buffer jump
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-b>", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
-- better window jump
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-S-p>", "<cmd>Telescope commands<cr>", opts)
keymap("n", "<F5>", "<cmd>RunFile<cr>", opts)
keymap("n", "<F6>", "<cmd>RunFileArgs<cr>", opts)

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context()
end, { silent = true })

vim.keymap.set('v', '<leader>y', require('osc52').copy_visual)

vim.keymap.set({ 'n' }, 'M', function()
  require('lsp_signature').toggle_float_win()
end, { silent = true, noremap = true, desc = 'toggle signature' })



