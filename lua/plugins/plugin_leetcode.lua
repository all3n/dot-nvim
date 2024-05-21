local M = {}
function M.setup()
  require("leetcode").setup {
    lang = "cpp",
    arg = "leet",
    cn = {     -- leetcode.cn
      enabled = true, ---@type boolean
      translator = true, ---@type boolean
      translate_problems = true, ---@type boolean
    },
    hooks = {
      LeetEnter = {
        function()
          -- vim.cmd.colorscheme("everforest")
        end
      }
    }
  }
end

return M
