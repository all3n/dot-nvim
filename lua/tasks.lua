local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local state = require('telescope.actions.state')
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}
function M.run_args()
  local tasks = vim.api.nvim_call_function("asynctasks#source", { 50 })
  if vim.tbl_isempty(tasks) then
    return
  end
  local tasks_formatted = {}
  for i = 1, #tasks do
    local current_task = table.concat(tasks[i], " | ")
    table.insert(tasks_formatted, current_task)
  end
  local opts = {}
  pickers.new(opts, {
    prompt_title    = 'Tasks',
    finder          = finders.new_table {

      results = tasks_formatted
    },
    sorter          = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      local start_task = function()
        local selection = state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        local task_name = tasks[selection.index][1]
        local task_cmd = tasks[selection.index][3]
        local cmd = table.concat({ "AsyncTask", task_name }, " ")
        local input = Input({
          position = "50%",
          size = {
            width = 120,
          },
          border = {
            style = "single",
            text = {
              top = task_name .. " args",
              top_align = "center",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
          },
        }, {
          prompt = "",
          default_value = "",
          on_close = function()
            print("Input Closed!")
          end,
          on_submit = function(value)
            if _G.all3nvim.exec_env ~= nil then
              vim.cmd("AsyncRun env=" .. _G.all3nvim.exec_env .. " " .. task_cmd .. " " .. value)
            else
              vim.cmd("AsyncRun " .. task_cmd .. " " .. value)
            end
          end,
        })
        input:mount()
        -- unmount component when cursor leaves buffer
        input:on(event.BufLeave, function()
          input:unmount()
        end)
        -- input end
      end
      map('i', '<CR>', start_task)
      map('n', '<CR>', start_task)
      return true
    end
  }):find()
end

function M.run_task(name)
  vim.cmd("AsyncTask " .. name .. " +envs=" .. _G.all3nvim.exec_env)
end

return M
