-- Setup language servers.
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require('lspconfig')
require("cmp_nvim_lsp").default_capabilities()
-- https://github.com/hrsh7th/cmp-nvim-lsp/issues/38
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = true
_G.all3nvim.default_capabilities = capabilities

-- autotools
if _G.all3nvim.plugins.autotools then
  lspconfig.autotools_ls.setup {
    capabilities = capabilities
  }
end

if _G.all3nvim.plugins.ast_grep then
  lspconfig.ast_grep.setup {
    capabilities = capabilities
  }
end


if _G.all3nvim.plugins.lua_ls then
  local capabilities = _G.all3nvim.default_capabilities
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
  -- lus ls config
  -- https://luals.github.io/wiki/settings/
  -- vim.notify(vim.inspect(lspconfig.lus_ls))
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            diagnostics = {
              globals = { "all3nvim", "vim" }
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        })
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      return true
    end
  }
end

if _G.all3nvim.plugins.tsserver then
  lspconfig.tsserver.setup {
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          -- location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
          -- macos
          location = "/opt/homebrew/lib/node_modules/@vue/typescript-plugin",
          languages = { "javascript", "typescript", "vue" },
        },
      },
    },
    filetypes = {
      "javascript",
      "typescript",
      "vue",
    },
    capabilities = capabilities
  }
  -- lspconfig.vuels.setup{
  -- capabilities = capabilities
  -- }
  lspconfig.volar.setup {
    capabilities = capabilities
  }
end

if _G.all3nvim.plugins.cmake then
  -- cmake
  lspconfig.cmake.setup {
    capabilities = capabilities
  }
end

-- xml
if _G.all3nvim.plugins.xml then
  lspconfig.lemminx.setup {
    capabilities = capabilities
  }
end

if _G.all3nvim.plugins.gopls then
  lspconfig.gopls.setup {
    capabilities = capabilities
  }
end

if _G.all3nvim.plugins.jsonls then
  -- json
  lspconfig.jsonls.setup {
    capabilities = capabilities,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas {
          extra = {
            {
              description = 'All3n NeoVIM JSON schema',
              fileMatch = { 'config.json' },
              name = 'config.json',
              url = 'file://' .. vim.fn.stdpath("config") .. "/configs/config.schema.json"
            }
          }
        },
        validate = { enable = true },
      },
    }
  }
end

if _G.all3nvim.plugins.yamlls then
  require('lspconfig').yamlls.setup {
    capabilities = capabilities,
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  }
end

if _G.all3nvim.plugins.pyright then
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/pyright.lua
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
  -- https://microsoft.github.io/pyright/#/settings
  lspconfig.pyright.setup {
    capabilities = capabilities
  }
end
if _G.all3nvim.plugins.rust_analyzer then
  lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {},
    },
  }
end

if _G.all3nvim.plugins.clangd then
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua
  local clangd_cmd = { "clangd", "--enable-config", "--clang-tidy", "--header-insertion=never",
    "--offset-encoding=utf-16" }
  -- default build background
  local build_index_background = true
  if build_index_background then
    table.insert(clangd_cmd, "--background-index")
  end
  lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = clangd_cmd
  }
end
if _G.all3nvim.plugins.bashls then
  lspconfig.bashls.setup {
    capabilities = capabilities,
  }
end
if _G.all3nvim.plugins.marksman then
  lspconfig.marksman.setup {
    capabilities = capabilities,
  }
end


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', ',e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', ',q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
