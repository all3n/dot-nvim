-- https://github.com/skywind3000/asynctasks.vim/blob/master/README-cn.md#%E5%AE%89%E8%A3%85
vim.g.asyncrun_open = 6
vim.g.asynctasks_term_pos = 'bottom'
vim.g.asynctasks_config_name = { '.tasks', '.git/tasks.ini', '.svn/tasks.ini', 'task.ini' }
vim.g.asynctasks_term_pos = 'toggleterm2'


vim.g.asyncrun_mode = 'term'
-- vim.g.asyncrun_mode = 'async' -- for quickfix

vim.g.asyncrun_save = 1 -- 1 save current file  2 save modified save
vim.g.asyncrun_open = 10
local task_file = vim.fn.stdpath("config") .. "/tasks.ini"
vim.g.asynctasks_extra_config = {
  task_file,
  '~/.config/tasks/local_tasks.ini'
}

vim.g.asyncrun_status = ''
