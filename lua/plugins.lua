local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- search plugins: https://dotfyle.com/neovim/plugins/trending
local function tabnine_build_path()
  if vim.loop.os_uname().sysname == "Windows_NT" then
    return "pwsh.exe -file .\\dl_binaries.ps1"
  else
    return "./dl_binaries.sh"
  end
end

-- plugin will install: ~/.local/share/nvim/lazy
require("lazy").setup({
  { "folke/lazy.nvim",             tag = "stable" },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("plugins.plugin_alpha")
    end
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {}
    end
  },
  { 'stevearc/dressing.nvim',      event = "VeryLazy",                                      config = true,                                opts = {},    dependencies = { "MunifTanjim/nui.nvim" } },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim",       cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" }, lazy = true },
  { "folke/neodev.nvim",           config = true },
  { "akinsho/bufferline.nvim",     version = "*",                                           dependencies = 'nvim-tree/nvim-web-devicons', config = true },
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cmd = "WhichKey",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("plugins.plugin_which_key")
    end
  },
  { "folke/tokyonight.nvim", lazy = not vim.startswith(all3nvim.colorscheme, "tokyonight") },
  { "sainnhe/everforest",    lazy = not vim.startswith(all3nvim.colorscheme, "everforest") },
  -- https://github.com/nvim-tree/nvim-tree.lua
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.plugin_nvimtree").setup()
    end,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    event = "User DirOpened",
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("plugins.plugin_symbols_outline").setup()
    end,
    cmd = { "SymbolsOutline" },
    lazy = true
  },
  {
    'fgheng/winbar.nvim',
    config = function()
      require("plugins.plugin_winbar").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugins.plugin_treesitter")
    end
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "nvim-treesitter/nvim-treesitter-context",    config = true },
  { "jose-elias-alvarez/null-ls.nvim",            config = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" }
  },
  { "mfussenegger/nvim-jdtls",      ft = "java" },
  { 'nvim-lua/popup.nvim' },
  { "nvim-telescope/telescope.nvim" },
  { "folke/trouble.nvim" },
  -- cmp
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    lazy = true,
    config = function()
      require("plugins.plugin_luasnip")
    end
  },
  { 'saadparwaiz1/cmp_luasnip' },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.plugin_nvim_cmp")
    end,
    event = { "InsertEnter", "CmdlineEnter" }
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("plugins.plugin_mason").setup()
    end
  },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "lewis6991/gitsigns.nvim",           config = true },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.plugin_lualine").setup()
    end
  },
  { "folke/trouble.nvim",           config = true },
  -- debug
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugins.plugin_dap").setup()
    end
  },
  { "rcarriga/nvim-dap-ui" },
  { "mfussenegger/nvim-dap-python", ft = "python" },
  {
    "Weissle/persistent-breakpoints.nvim",
    config = function()
      require('persistent-breakpoints').setup {
        load_breakpoints_event = { "BufReadPost" }
      }
    end
  },
  -- jumper
  { "ThePrimeagen/harpoon",  config = true },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup {}
    end
  },
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false
  },
  {
    'akinsho/nvim-toggleterm.lua',
    version = "*",
    config = function()
      require("plugins.plugin_toggleterm").setup()
    end
  },
  -- persistence for load last state
  {
    'folke/persistence.nvim',
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("cache") .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
        pre_save = nil,
      })
    end
  },
  {
    "codota/tabnine-nvim",
    build = tabnine_build_path(),
    enabled = _G.all3nvim.plugins.tabnine,
    config = function()
      require('tabnine').setup({
        disable_auto_comment = true,
        accept_keymap = "<C-y>",
        dismiss_keymap = "<C-n>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt" },
        log_file_path = nil, -- absolute path to Tabnine log file
      })
    end
  },
  {
    "skywind3000/asyncrun.vim",
    name = "asyncrun",
    config = function()
      require("asyncrun_toggleterm").setup({
        mapping = "<leader>tt",
        start_in_insert = false,
      })
    end
  },
  {
    'skywind3000/asynctasks.vim',
    config = function()
      require "plugins.plugin_async_tasks"
    end
  },
  { 'GustavoKatel/telescope-asynctasks.nvim' },
  { 'phaazon/hop.nvim',                      config = true },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require("notify")
    end
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup()
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
    end
  },
  {
    "p00f/clangd_extensions.nvim",
    -- ft = { "c", "c++", "cpp", "cuda" }, lazy = true,
    config = function()
      require("clangd_extensions").setup {
        inlay_hints = {
          autoSetHints = false
        }
      }
    end
  },
  {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("plugins.plugin_browse").setup()
    end
  },
  {
    "nvim-lua/lsp-status.nvim",
  },
  {
    "cshuaimin/ssr.nvim",
    config = function()
      require("ssr").setup()
    end
  },
  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    config = function()
      require('distant'):setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
})
require("plugins.plugin_lsp_config")
