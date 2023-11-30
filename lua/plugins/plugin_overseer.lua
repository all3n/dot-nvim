local M = {}
-- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#setup-options
function M.setup()
  local toggleterm = require("overseer.strategy.toggleterm")
  require("overseer").setup({
    strategy = {
      "toggleterm",
      use_shell = false,
      direction = "horizontal",
      highlights = nil,
      auto_scroll = nil,
      close_on_exit = false,
      quit_on_exit = "never",
      open_on_start = true,
      hidden = false,
      on_create = nil,
    },
    default_template_prompt = "always",
    templates = {
      "builtin",
      "user.run_script"
    }
  })
end

return M
