local M = {}

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]

M.defaults = {
  {
    name = "BufferKill",
    fn = function()
      require("plugins.plugin_bufferline").buf_kill "bd"
    end,
  },
  {
    name = "ChangeEnv",
    fn = function()
      if _G.all3nvim.change_env ~= nil and _G.all3nvim.envs ~= nil then
        _G.all3nvim.change_env(_G.all3nvim.envs)
      end
    end
  },
  {
    name = "RunFile",
    fn = function()
      require("all3nvim.executor").execute(nil)
    end
  },
  {
    name = "RunFileArgs",
    fn = function()
      require("ui_widgets").input_popup("args", function(args)
        require("all3nvim.executor").execute(args)
      end)
    end
  }

}

function M.load(collection)
  local common_opts = { force = true }
  for _, cmd in pairs(collection) do
    local opts = vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
    vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
  end
end

return M
