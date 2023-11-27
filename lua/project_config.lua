local M = {}
local utils = require("utils")
function M.get_project_json()
  local project_name = utils.get_project_name()
  local project_dir = join_paths(vim.fn.stdpath("data"), "project_configs", project_name)
  utils.create_directory_if_not_exists(join_paths(vim.fn.stdpath("data"), "project_configs"))
  utils.create_directory_if_not_exists(project_dir)
  return join_paths(project_dir, "project.json")
end

function M.get()
  local project_json_path = M.get_project_json()
  local ok, data = utils.json_decode(project_json_path)
  if ok then
    return data
  else
    -- vim.notify(data)
    return nil
  end
end

function M.save(opts)
  local project_json_path = M.get_project_json()
  local project_json = vim.fn.json_encode(opts)
  local file = io.open(project_json_path, "w")
  if file then
    file:write(project_json)
    file:close()
  else
    vim.notify("fail save project config:" .. project_json_path)
  end
end

return M
