local health = vim.health or require "health"
local M = {}
function M.check()
  health.report_ok("check ok")
end
return M
