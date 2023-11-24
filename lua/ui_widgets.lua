local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local state = require('telescope.actions.state')


-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md

local M = {}
function M.build_picker(title, choices, call_back)
  local picker_fn = function(opts)
    opts = opts or {}
    pickers.new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = choices,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        local start_task = function()
          local selection = state.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)
          local choice = choices[selection.index]
          vim.notify(vim.inspect(choice))
          if call_back ~= nil then
            call_back(choice)
          end
        end
        map('i', '<CR>', start_task)
        map('n', '<CR>', start_task)
        return true
      end,
    }):find()
  end
  return picker_fn
end
return M
