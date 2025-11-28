local proxy_github = ''
if type(_G.all3nvim) == "table" then
  if _G.all3nvim.use_github_proxy then
    proxy_github = _G.all3nvim.github_proxy or ""
    if proxy_github ~= "" then
      proxy_github = proxy_github .. "/"
    end
  end
end

local function clone_with_progress(repo_url, target_path)
  print("Cloning " .. repo_url)
  print("Target: " .. target_path)

  local done = false
  local success = false

  vim.fn.jobstart({ "git", "clone", "--progress", repo_url, "--branch=stable", target_path }, {
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= "" then
          print("git: " .. line)
        end
      end
    end,
    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= "" then
          print("git: " .. line)
        end
      end
    end,
    on_exit = function(_, exit_code, _)
      done = true
      success = exit_code == 0
    end
  })

  -- 等待任务完成
  while not done do
    vim.wait(100, function() return done end)
  end

  return success
end



local function setup_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  -- 检查并安装
  if not vim.loop.fs_stat(lazypath) then
    local repo_url = "https://" .. proxy_github .. "github.com/folke/lazy.nvim.git"
    if not vim.loop.fs_stat(lazypath) then
      local success = clone_with_progress(repo_url, lazypath)
      if not success then
        print("ERROR: Git clone failed")
        os.exit(1)
      end
    end
  end

  -- 验证安装
  if vim.loop.fs_stat(lazypath) then
    vim.opt.rtp:prepend(lazypath)
    return true
  else
    vim.notify("lazy.nvim installation verification failed", vim.log.levels.ERROR)
    return false
  end
end

-- 执行安装
local success = setup_lazy()
if not success then
  vim.notify("lazy.nvim setup failed, plugin management may not work", vim.log.levels.WARN)
end


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
  { "folke/lazy.nvim",       tag = "stable" },
  { "folke/tokyonight.nvim", lazy = not vim.startswith(all3nvim.colorscheme, "tokyonight") },
  { "sainnhe/everforest",    lazy = not vim.startswith(all3nvim.colorscheme, "everforest") },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("plugins.plugin_alpha")
    end
  },
  -- {
  --   "DrKJeff16/project.nvim",
  --   config = function()
  --     require("project_nvim").setup {}
  --   end
  -- },
  { 'stevearc/dressing.nvim',      event = "VeryLazy",                                      config = true,                                opts = {},    dependencies = { "MunifTanjim/nui.nvim" } },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim",       cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" }, lazy = true }, -- 工具库 
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
  { "nvimtools/none-ls.nvim",                     config = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" }
  },
  { "j-hui/fidget.nvim",            config = true },
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
    version = "v2.3.0",
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
    "williamboman/mason.nvim", -- package manager
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
  -- debug
  { "folke/trouble.nvim",              config = true },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugins.plugin_dap").setup()
    end
  },
  { "theHamsta/nvim-dap-virtual-text", config = true },
  { "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "mfussenegger/nvim-dap-python",    ft = "python",                                                      enabled = _G.all3nvim.plugins.python or false },
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
  -- {
  --   "skywind3000/asyncrun.vim",
  --   name = "asyncrun",
  --   config = function()
  --     require("asyncrun_toggleterm").setup({
  --       mapping = "<leader>tt",
  --       start_in_insert = false,
  --     })
  --   end
  -- },
  -- {
  --   'skywind3000/asynctasks.vim',
  --   config = function()
  --     require "plugins.plugin_async_tasks"
  --   end
  -- },
  -- { 'GustavoKatel/telescope-asynctasks.nvim' },
  { 'phaazon/hop.nvim', config = true },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require("notify")
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    -- event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    "p00f/clangd_extensions.nvim",
    enabled = _G.all3nvim.plugins.cpp or false,
    ft = { "c", "c++", "cpp", "cuda" },
    lazy = true,
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
    "cshuaimin/ssr.nvim",
    config = function()
      require("ssr").setup()
    end
  },
  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    enabled = _G.all3nvim.plugins.distant or false,
    config = function()
      require('distant'):setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    enabled = _G.all3nvim.plugins.markdown or false,
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  --{
  --  'stevearc/overseer.nvim',
  --  config = function()
  --    require('plugins.plugin_overseer').setup()
  --  end
  --},
  {
    -- Interactive Repl Over Neovim
    'Vigemus/iron.nvim',
    enabled = _G.all3nvim.plugins.python or false,
    config = function()
      require("plugins.plugin_iron").setup()
    end
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    enabled = _G.all3nvim.plugins.leetcode or false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("plugins.plugin_leetcode").setup()
    end
  },
  {
    'ojroques/nvim-osc52',
    config = function()
      require('osc52').setup {
        max_length = 0,           -- Maximum length of selection (0 for no limit)
        silent = false,           -- Disable message on successful copy
        trim = false,             -- Trim surrounding whitespaces before copy
        tmux_passthrough = false, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
        -- tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
      }
      -- set g maybe very slow
      -- vim.g.clipboard = {
      --   name = 'OSC 52',
      --   copy = {
      --     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      --     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      --   },
      --   paste = {
      --     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      --     ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      --   },
      -- }
    end
  },
  {
    -- for golang
    "ray-x/go.nvim",
    enabled = _G.all3nvim.plugins.gopls,
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()'
    -- if you need to install/update all binaries
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt"
      --, "java"
    },
    enabled = _G.all3nvim.plugins.metals or false,
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },
  {
    "aserowy/tmux.nvim",
    config = function() return require("tmux").setup() end,
    enabled = false
  }
}, {
  git = {
    url_format = "https://" .. proxy_github .. "github.com/%s.git"
  }
})
require("plugins.plugin_lsp_config")
