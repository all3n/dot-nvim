local wk = require("which-key")

-- https://github.com/folke/which-key.nvim
-- wk.register({
--   ["<space>"] = {
--     "<Plug>(comment_toggle_linewise_current)",
--     "comment_toggle_linewise_current"
--   },
--   [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
--   ["w"] = { "<cmd>w!<CR>", "Save" },
--   ["q"] = { "<cmd>confirm q<CR>", "Quit" },
--   ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
--   ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
--   e = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
--   b = {
--     name = "Buffers",
--     j = { "<cmd>BufferLinePick<cr>", "Jump" },
--     f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
--     b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
--     n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
--     W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
--     -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
--     e = {
--       "<cmd>BufferLinePickClose<cr>",
--       "Pick which buffer to close",
--     },
--     h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
--     l = {
--       "<cmd>BufferLineCloseRight<cr>",
--       "Close all to the right",
--     },
--     D = {
--       "<cmd>BufferLineSortByDirectory<cr>",
--       "Sort by directory",
--     },
--     L = {
--       "<cmd>BufferLineSortByExtension<cr>",
--       "Sort by language",
--     },
--     p = {
--       "<cmd>BufferLineTogglePin<cr>",
--       "BufferTogglePin",
--     },
--     o = {
--       "<cmd>BufferLineCloseOthers<cr>",
--       "BufferCloseOthers",
--     },
--   },
--   d = {
--     name = "Debug",
--     t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
--     b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
--     c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
--     C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
--     d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
--     g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
--     i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
--     o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
--     u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
--     p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
--     r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
--     s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
--     q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
--     U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
--   },
--   p = {
--     name = "Plugins",
--     i = { "<cmd>Lazy install<cr>", "Install" },
--     s = { "<cmd>Lazy sync<cr>", "Sync" },
--     S = { "<cmd>Lazy clear<cr>", "Status" },
--     c = { "<cmd>Lazy clean<cr>", "Clean" },
--     u = { "<cmd>Lazy update<cr>", "Update" },
--     p = { "<cmd>Lazy profile<cr>", "Profile" },
--     l = { "<cmd>Lazy log<cr>", "Log" },
--     d = { "<cmd>Lazy debug<cr>", "Debug" },
--   },
--   l = {
--     name = "LSP",
--     a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
--     d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
--     w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
--     f = { "<cmd>lua require('lsp').format()<cr>", "Format" },
--     i = { "<cmd>LspInfo<cr>", "Info" },
--     I = { "<cmd>Mason<cr>", "Mason Info" },
--     j = {
--       "<cmd>lua vim.diagnostic.goto_next()<cr>",
--       "Next Diagnostic",
--     },
--     k = {
--       "<cmd>lua vim.diagnostic.goto_prev()<cr>",
--       "Prev Diagnostic",
--     },
--     l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
--     q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
--     r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
--     s = { "<cmd>Telesope lsp_document_symbols<cr>", "Document Symbols" },
--     S = {
--       "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
--       "Workspace Symbols",
--     },
--     e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
--     c = { "<cmd>ChangeEnv<cr>", "Change environment" }
--   },
--   s = {
--     s = { "<cmd>Telescope<cr>", "Telescope" },
--     n = { "<cmd>Telescope notify<cr>", "Notify" },
--     b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--     c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
--     f = { "<cmd>Telescope find_files<cr>", "Find File" },
--     h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
--     H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
--     M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
--     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--     R = { "<cmd>Telescope registers<cr>", "Registers" },
--     t = { "<cmd>Telescope live_grep<cr>", "Text" },
--     k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
--     C = { "<cmd>Telescope commands<cr>", "Commands" },
--     l = { "<cmd>Telescope resume<cr>", "Resume last search" },
--     p = {
--       "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
--       "Colorscheme with Preview",
--     },
--   },
--   T = {
--     name = "Treesitter",
--     i = { ":TSConfigInfo<cr>", "Info" }
--   },
--   t = {
--     name = "toggle",
--     t = { "<cmd>Telescope asynctasks all<cr>", "AsyncTasksList" },
--     o = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" },
--     h = { "<cmd>ClangdSwitchSourceHeader<cr>", "ClangdSwitchSourceHeader" },
--     r = { "<cmd>TroubleToggle<cr>", "TroubleToggle" }
--   },
--   r = {
--     name = "+Run",
--     l = { "<cmd>AsyncTaskList<cr>", "AsyncTaskList" },
--     P = { "<cmd>AsyncTaskProfile<cr>", "AsyncTaskProfile" },
--     m = { "<cmd>AsyncTaskMacro<cr>", "AsyncTaskMacro" },
--     r = { "<cmd>RunFile<cr>", "run file" },
--     a = { "<cmd>RunFileArgs<cr>", "run file args" },
--     b = { "<cmd>RunBuild<cr>", "run file build" },
--     t = { "<cmd>lua require('plugins.plugin_toggleterm').get_term('build_term'):toggle()<cr>", "toggle build" },
--     T = { "<cmd>lua require('test').input()<cr>", "Test" }
--   },
--   h = {
--     name = "Hop",
--     w = { "<cmd>HopWord<cr>", "HopWord" }
--   },
--   g = {
--     name = "Git",
--     g = { "<cmd>lua require 'plugins.plugin_toggleterm'.lazygit_toggle()<cr>", "Lazygit" },
--     j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
--     k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
--     l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
--     p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
--     r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
--     R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
--     s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
--     u = {
--       "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
--       "Undo Stage Hunk",
--     },
--     o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
--     b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--     B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle Current Line Blame" },
--     c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
--     C = {
--       "<cmd>Telescope git_bcommits<cr>",
--       -- "Checkout commit(for current file)",
--     },
--     d = {
--       "<cmd>Gitsigns diffthis HEAD<cr>",
--       "Git Diff",
--     },
--   },
--   o = {
--     "Open",
--     B = { "<cmd>lua require('browse').browse()<cr>", "browse" },
--     r = { "<cmd>OverseerRun<cr>", "OverseerRun" },
--     x = { "<cmd>OverseerClose<cr>", "OverseerClose" },
--     b = { "<cmd>OverseerRunBuild<cr>", "OverseerBuild" },
--     c = { "<cmd>OverseerRunCmd<cr>", "OverseerRunCmd" },
--     t = { "<cmd>OverseerToggle<cr>", "OverseerToggle" },
--     i = { "<cmd>OverseerInfo<cr>", "OverseerInfo" }
--   },
--   n = {
--     name = "neovim",
--     c = { "<cmd>checkhealth<cr>", "checkhealth" },
--     v = { "<cmd>lua vim.print(vim.inspect(_G.all3nvim))<cr>", "ShowVars" }
--   },
--   m = {
--     name = "Markdown",
--     t = { "<cmd>MarkdownPreviewToggle<cr>", "MarkdownPreviewToggle" },
--     f = { "<cmd>MarkdownPreview<cr>", "MarkdownPreview" },
--     p = { "<cmd>MarkdownPreviewStop<cr>", "MarkdownPreviewStop" }
--   }
-- }, { prefix = "<leader>" })





wk.add({
    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
    { "<leader>;", "<cmd>Alpha<CR>", desc = "Dashboard" },
    { "<leader><space>", "<Plug>(comment_toggle_linewise_current)", desc = "comment_toggle_linewise_current" },
    { "<leader>T", group = "Treesitter" },
    { "<leader>Ti", ":TSConfigInfo<cr>", desc = "Info" },
    { "<leader>b", group = "Buffers" },
    { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
    { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
    { "<leader>bW", "<cmd>noautocmd w<cr>", desc = "Save without formatting (noautocmd)" },
    { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
    { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close" },
    { "<leader>bf", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find" },
    { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
    { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
    { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "BufferCloseOthers" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "BufferTogglePin" },
    { "<leader>c", "<cmd>BufferKill<CR>", desc = "Close Buffer" },
    { "<leader>d", group = "Debug" },
    { "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run To Cursor" },
    { "<leader>dU", "<cmd>lua require'dapui'.toggle({reset = true})<cr>", desc = "Toggle UI" },
    { "<leader>db", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back" },
    { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
    { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect" },
    { "<leader>dg", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session" },
    { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
    { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
    { "<leader>dp", "<cmd>lua require'dap'.pause()<cr>", desc = "Pause" },
    { "<leader>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit" },
    { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl" },
    { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>", desc = "Start" },
    { "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
    { "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    { "<leader>g", group = "Git" },
    { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Current Line Blame" },
    { "<leader>gC", desc = "<cmd>Telescope git_bcommits<cr>" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
    { "<leader>gg", "<cmd>lua require 'plugins.plugin_toggleterm'.lazygit_toggle()<cr>", desc = "Lazygit" },
    { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
    { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk" },
    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
    { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
    { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
    { "<leader>h", group = "Hop" },
    { "<leader>hw", "<cmd>HopWord<cr>", desc = "HopWord" },
    { "<leader>l", group = "LSP" },
    { "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    { "<leader>lc", "<cmd>ChangeEnv<cr>", desc = "Change environment" },
    { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", desc = "Buffer Diagnostics" },
    { "<leader>le", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quickfix" },
    { "<leader>lf", "<cmd>lua require('lsp').format()<cr>", desc = "Format" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>ls", "<cmd>Telesope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>m", group = "Markdown" },
    { "<leader>mf", "<cmd>MarkdownPreview<cr>", desc = "MarkdownPreview" },
    { "<leader>mp", "<cmd>MarkdownPreviewStop<cr>", desc = "MarkdownPreviewStop" },
    { "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", desc = "MarkdownPreviewToggle" },
    { "<leader>n", group = "neovim" },
    { "<leader>nc", "<cmd>checkhealth<cr>", desc = "checkhealth" },
    { "<leader>nv", "<cmd>lua vim.print(vim.inspect(_G.all3nvim))<cr>", desc = "ShowVars" },
    { "<leader>o", desc = "Open" },
    { "<leader>oB", "<cmd>lua require('browse').browse()<cr>", desc = "browse" },
    { "<leader>ob", "<cmd>OverseerRunBuild<cr>", desc = "OverseerBuild" },
    { "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "OverseerRunCmd" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "OverseerInfo" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "OverseerRun" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "OverseerToggle" },
    { "<leader>ox", "<cmd>OverseerClose<cr>", desc = "OverseerClose" },
    { "<leader>p", group = "Plugins" },
    { "<leader>pS", "<cmd>Lazy clear<cr>", desc = "Status" },
    { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
    { "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },
    { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
    { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
    { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
    { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
    { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
    { "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
    { "<leader>r", group = "Run" },
    { "<leader>rP", "<cmd>AsyncTaskProfile<cr>", desc = "AsyncTaskProfile" },
    { "<leader>rT", "<cmd>lua require('test').input()<cr>", desc = "Test" },
    { "<leader>ra", "<cmd>RunFileArgs<cr>", desc = "run file args" },
    { "<leader>rb", "<cmd>RunBuild<cr>", desc = "run file build" },
    { "<leader>rl", "<cmd>AsyncTaskList<cr>", desc = "AsyncTaskList" },
    { "<leader>rm", "<cmd>AsyncTaskMacro<cr>", desc = "AsyncTaskMacro" },
    { "<leader>rr", "<cmd>RunFile<cr>", desc = "run file" },
    { "<leader>rt", "<cmd>lua require('plugins.plugin_toggleterm').get_term('build_term'):toggle()<cr>", desc = "toggle build" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find highlight groups" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
    { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
    { "<leader>sn", "<cmd>Telescope notify<cr>", desc = "Notify" },
    { "<leader>sp", "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", desc = "Colorscheme with Preview" },
    { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
    { "<leader>ss", "<cmd>Telescope<cr>", desc = "Telescope" },
    { "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Text" },
    { "<leader>t", group = "toggle" },
    { "<leader>th", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "ClangdSwitchSourceHeader" },
    { "<leader>to", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
    { "<leader>tr", "<cmd>TroubleToggle<cr>", desc = "TroubleToggle" },
    { "<leader>tt", "<cmd>Telescope asynctasks all<cr>", desc = "AsyncTasksList" },
    { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
  });








-- visual which key
-- wk.register({
--   ["<space>"] = {
--     "<Plug>(comment_toggle_linewise_visual)",
--     "comment_toggle_linewise_visual"
--   },
--   s = {
--     r = { "<cmd>lua require 'ssr'.open()<cr>", "RenameBlock" },
--   }
-- }, { prefix = "<leader>", mode = "v" })


wk.add({
    { "<leader><space>", "<Plug>(comment_toggle_linewise_visual)", desc = "comment_toggle_linewise_visual", mode = "v" },
    { "<leader>sr", "<cmd>lua require 'ssr'.open()<cr>", desc = "RenameBlock", mode = "v" },
})


