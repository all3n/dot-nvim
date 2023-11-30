local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local state = require('telescope.actions.state')

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event


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

function M.input_popup(title, fn, popup_opts, input_opts)
  local default_popup_opts = {
    position = "50%",
    size = {
      width = 120,
    },
    border = {
      style = "single",
      text = {
        top = title,
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }
  local default_input_opts = {
    prompt = ">",
    default_value = "",
    on_submit = fn
  }

  if popup_opts == nil then
    popup_opts = default_popup_opts
  else
    popup_opts = vim.tbl_extend("force", default_popup_opts, popup_opts)
  end
  if input_opts == nil then
    input_opts = default_input_opts
  else
    input_opts = vim.tbl_extend("force", default_input_opts, input_opts)
  end

  local input = Input(popup_opts, input_opts)
  input:mount()
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

return M
