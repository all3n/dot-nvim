local util = require 'lspconfig.util'
local java = _G.all3nvim.java
local java_envs = java.envs
local java_runtimes = {}
for k, v in pairs(java_envs) do
  java_envs[k] = vim.api.nvim_call_function("expand", { v })
  -- jdtls runtime not support 21
  if k ~= "JavaSE-21" then
    table.insert(java_runtimes, { name = k, path = java_envs[k] })
  end
end
if java.lsp.jdtls_home ~= nil then
  java.lsp.jdtls_home = vim.api.nvim_call_function("expand", { java.lsp.jdtls_home })
end

-- you should download jdtls first,un archive to ~/opt/jdtls-x.x.x
-- set JDTLS_HOME=$HOME/opt/jdtls-x.x.x
-- JDTLS_JAVA must > java17
-- set JDTLS_JAVA=/path/xxx/bin/java
-- https://github.com/eclipse-jdtls/eclipse.jdt.ls
local utils_tool = require("utils")
local jdtls_data = vim.fn.stdpath("data") .. "/jdtls"
utils_tool.create_directory_if_not_exists(jdtls_data)
local lombak_jar = jdtls_data .. "/lombak.jar"
local lombak_url = "https://projectlombok.org/downloads/lombok.jar"
utils_tool.download_file(lombak_url, lombak_jar)


local env = {
  HOME = vim.loop.os_homedir(),
  JDTLS_HOME = os.getenv 'JDTLS_HOME',
  JAVA_HOME = os.getenv 'JAVA_HOME',
  JDK8_HOME = os.getenv 'JDK8_HOME',
  JDK13_HOME = os.getenv 'JDK13_HOME',
  JDK17_HOME = os.getenv 'JDK17_HOME',
  XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
  JAVA_DEBUG = os.getenv 'JAVA_DEBUG',
  JDTLS_CONFIG = os.getenv 'JDTLS_CONFIG',
  JDTLS_JAVA = os.getenv 'JDTLS_JAVA'
}
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local function get_cache_dir()
  return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or util.path.join(env.HOME, '.cache')
end

local function get_jdtls_cache_dir()
  return util.path.join(get_cache_dir(), 'jdtls')
end

local function get_jdtls_workspace_dir()
  return util.path.join(get_jdtls_cache_dir(), 'workspace') .. project_name
end

local function get_os_config()
  local os_info = vim.loop.os_uname()
  if env.JDTLS_CONFIG then
    return env.JDTLS_CONFIG
  elseif os_info.sysname == "Windows" then
    return "config_win"
  elseif os_info.sysname == "Linux" then
    local handle = io.popen('uname -m')
    if handle then
      local arch = handle:read('*a')
      arch = arch:sub(1, -2)
      handle:close()
      if arch == "arm64" then
        return "config_linux_arm"
      end
    end
    return "config_linux"
  elseif os_info.sysname == "Darwin" then
    local handle = io.popen('uname -m')
    if handle then
      local arch = handle:read('*a')
      arch = arch:sub(1, -2)
      handle:close()
      if arch == "arm64" then
        return "config_mac_arm"
      end
    end
    return "config_mac"
  else
    return "unknown"
  end
end

-- not use jdtls python wrapper
-- local jdtls_bin = util.path.join(env.JDTLS_HOME, '/bin/jdtls')

local java_bin = nil
if env.JDTLS_JAVA then
  java_bin = env.JDTLS_JAVA
elseif java.lsp.jdtls_env ~= nil then
  local lsp_env_name = java.lsp.jdtls_env
  java_bin = util.path.join(java_envs[lsp_env_name], '/bin/java')
else
  java_bin = util.path.join(env.JAVA_HOME, '/bin/java')
end
_G.all3nvim.env = java_bin
local java_debug_path = util.path.join(env.JAVA_DEBUG, 'com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar')

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/jdtls.lua
local function get_jdtls_jvm_args()
  local args = {}
  for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
    local arg = string.format('--jvm-arg=%s', a)
    table.insert(args, arg)
  end
  return unpack(args)
end
local jdtls_home = env.JDTLS_HOME
if jdtls_home == nil then
  jdtls_home = java.lsp.jdtls_home
end

-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
local config = {
  cmd = {
    java_bin,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. lombak_jar,
    '-jar', vim.fn.glob(util.path.join(jdtls_home, '/plugins/org.eclipse.equinox.launcher_*.jar'), 1),
    '-configuration', util.path.join(jdtls_home, get_os_config()),
    '-data', get_jdtls_workspace_dir(),
    get_jdtls_jvm_args()
  },
  filetypes = { 'java' },
  root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml' }),
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = "file://" .. vim.fn.stdpath("config").. "/configs/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = java_runtimes
      }
    }
  },
  signatureHelp = { enabled = true },
  completion = {
    favoriteStaticMembers = {
      "org.hamcrest.MatcherAssert.assertThat",
      "org.hamcrest.Matchers.*",
      "org.hamcrest.CoreMatchers.*",
      "org.junit.jupiter.api.Assertions.*",
      "java.util.Objects.requireNonNull",
      "java.util.Objects.requireNonNullElse",
      "org.mockito.Mockito.*",
    },
  },
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  init_options = {
    bundles = {
      vim.fn.glob(java_debug_path, 1)
    }
  },
}
config['on_attach'] = function(client, bufnr)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- Remove the option if you do not want that.
  -- You can use the `JdtHotcodeReplace` command to trigger it manually
  -- require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end
vim.cmd([[
  nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
  nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
  vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
  nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
  vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
  vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
  nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
  nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
]])

require('jdtls').start_or_attach(config)
