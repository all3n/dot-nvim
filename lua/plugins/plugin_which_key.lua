local wk = require("which-key")

-- https://github.com/folke/which-key.nvim
wk.register({
  ["<space>"] = {
    "<Plug>(comment_toggle_linewise_current)",
    "comment_toggle_linewise_current"
  },
  [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>confirm q<CR>", "Quit" },
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
  ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
  e = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
  b = {
    name = "Buffers",
    j = { "<cmd>BufferLinePick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
    b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
    n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
    W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
    -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
    e = {
      "<cmd>BufferLinePickClose<cr>",
      "Pick which buffer to close",
    },
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = {
      "<cmd>BufferLineCloseRight<cr>",
      "Close all to the right",
    },
    D = {
      "<cmd>BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      "<cmd>BufferLineSortByExtension<cr>",
      "Sort by language",
    },
    p = {
      "<cmd>BufferLineTogglePin<cr>",
      "BufferTogglePin",
    },
    o = {
      "<cmd>BufferLineCloseOthers<cr>",
      "BufferCloseOthers",
    },
  },
  d = {
    name = "Debug",
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
  },
  p = {
    name = "Plugins",
    i = { "<cmd>Lazy install<cr>", "Install" },
    s = { "<cmd>Lazy sync<cr>", "Sync" },
    S = { "<cmd>Lazy clear<cr>", "Status" },
    c = { "<cmd>Lazy clean<cr>", "Clean" },
    u = { "<cmd>Lazy update<cr>", "Update" },
    p = { "<cmd>Lazy profile<cr>", "Profile" },
    l = { "<cmd>Lazy log<cr>", "Log" },
    d = { "<cmd>Lazy debug<cr>", "Debug" },
  },
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    f = { "<cmd>lua require('lsp').format()<cr>", "Format" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>Mason<cr>", "Mason Info" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telesope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    c = { "<cmd>ChangeEnv<cr>", "Change environment" }
  },
  s = {
    s = { "<cmd>Telescope<cr>", "Telescope" },
    n = { "<cmd>Telescope notify<cr>", "Notify" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>Telescope live_grep<cr>", "Text" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    l = { "<cmd>Telescope resume<cr>", "Resume last search" },
    p = {
      "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },
  },
  T = {
    name = "Treesitter",
    i = { ":TSConfigInfo<cr>", "Info" }
  },
  t = {
    name = "toggle",
    t = { "<cmd>Telescope asynctasks all<cr>", "AsyncTasksList" },
    o = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" },
    h = { "<cmd>ClangdSwitchSourceHeader<cr>", "ClangdSwitchSourceHeader" },
    r = { "<cmd>TroubleToggle<cr>", "TroubleToggle" }
  },
  r = {
    name = "+Run",
    l = { "<cmd>AsyncTaskList<cr>", "AsyncTaskList" },
    P = { "<cmd>AsyncTaskProfile<cr>", "AsyncTaskProfile" },
    m = { "<cmd>AsyncTaskMacro<cr>", "AsyncTaskMacro" },
    b = { "<cmd>AsyncTask file-build<cr>", "task:build" },
    r = { "<cmd>lua require 'tasks'.run_task('file-run')<cr>", "task:run" },
    a = { "<cmd>lua require 'tasks'.run_args()<cr>", "run args" },
    p = {
      "+Project",
      b = { "<cmd>AsyncTask project-build<cr>", "task:project:build" },
      r = { "<cmd>AsyncTask project-run<cr>", "task:project:run" },
    },
    T = { "<cmd>lua require('test').input()<cr>", "Test" }
  },
  h = {
    name = "Hop",
    w = { "<cmd>HopWord<cr>", "HopWord" }
  },
  g = {
    name = "Git",
    g = { "<cmd>lua require 'plugins.plugin_toggleterm'.lazygit_toggle()<cr>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle Current Line Blame" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = {
      "<cmd>Telescope git_bcommits<cr>",
      -- "Checkout commit(for current file)",
    },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Git Diff",
    },
  },
  o = {
    "Open",
    b = { "<cmd>lua require('browse').browse()<cr>", "browse" }
  },
  n = {
    name = "neovim",
    c = { "<cmd>checkhealth<cr>", "checkhealth" },
    v = { "<cmd>lua vim.print(vim.inspect(_G.all3nvim))<cr>", "ShowVars" }
  }
}, { prefix = "<leader>" })



-- visual which key
wk.register({
  ["<space>"] = {
    "<Plug>(comment_toggle_linewise_visual)",
    "comment_toggle_linewise_visual"
  },
  s = {
    r = { "<cmd>lua require 'ssr'.open()<cr>", "RenameBlock" },
  }
}, { prefix = "<leader>", mode = "v" })
