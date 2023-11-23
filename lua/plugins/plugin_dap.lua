local M = {}
local dap, dapui = require("dap"), require("dapui")
local icons = require("icons")
M.signs = {
  breakpoint = {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  },
  breakpoint_rejected = {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = icons.ui.BoldArrowRight,
    texthl = "DiagnosticSignWarn",
    linehl = "Visual",
    numhl = "DiagnosticSignWarn",
  }
}

function M.setup()
  -- define dap sign icon
  vim.fn.sign_define("DapBreakpoint", M.signs.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", M.signs.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", M.signs.stopped)

  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
  M.set_adapter_codelldb()
end

local utils = require("utils")
function M.set_adapter_codelldb()
  local detached = true
  if utils.isWindows() then
    detached = false
  end
  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      command = 'codelldb',
      args = { "--port", "${port}" },
      detached = detached
    }
  }

  dap.configurations.c = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
  dap.configurations.cpp = dap.configurations.c
  dap.configurations.rust = dap.configurations.rust
end

return M
