local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

function M.isWindows()
  local sysname = vim.loop.os_uname().sysname
  return sysname:match("Windows") ~= nil
end

function M.create_directory_if_not_exists(directory_path)
  local success, error_message = vim.loop.fs_stat(directory_path)
  if success == nil then
    -- Directory does not exist, create it
    local result, create_error = vim.loop.fs_mkdir(directory_path, 484) -- 484 is the default permission for directories
    if result == nil then
      vim.notify("Failed to create directory: " .. create_error)
      return
    end
    -- vim.notify("Directory created: " .. directory_path)
  end
end

function M.download_file(url, local_path)
  local success, error_message = vim.loop.fs_stat(local_path)
  if success ~= nil then
    return
  end
  local local_dir = vim.fn.fnamemodify(local_path, ":h")
  if vim.fn.isdirectory(local_dir) == 0 then
    local success2, create_error = vim.loop.fs_mkdir(local_dir, 484) -- 484 is the default permission for directories
    if success2 == nil then
      print("Failed to create directory: " .. create_error)
      return
    end
  end
  -- Download the file using curl
  local command = string.format("curl -o %s %s", local_path, url)
  vim.notify(command)
  local result = vim.fn.system(command)
  if result == 0 then
    print("File downloaded: " .. local_path)
  else
    print("Failed to download file.")
  end
end

function M.remove_comments(json)
  local lines = vim.split(json, '\n')
  local filtered_lines = {}
  for _, line in ipairs(lines) do
    if not line:match('^%s*//') then
      table.insert(filtered_lines, line)
    end
  end
  return table.concat(filtered_lines, '\n')
end

function M.json_decode(filepath)
  local json_file = io.open(filepath, 'r')
  if json_file == nil then
    return false, 'JSON file not found'
  end
  local json_content = M.remove_comments(json_file:read('*all'))
  json_file:close()
  local ok, result = pcall(vim.fn.json_decode, json_content)
  if ok then
    return true, result
  else
    return false, "json parse fail" .. result
  end
end

function M.fs_copy(source, destination)
  local source_stats = assert(vim.loop.fs_stat(source))

  if source_stats.type == "file" then
    assert(vim.loop.fs_copyfile(source, destination))
    return
  elseif source_stats.type == "directory" then
    local handle = assert(vim.loop.fs_scandir(source))

    assert(vim.loop.fs_mkdir(destination, source_stats.mode))

    while true do
      local name = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end

      M.fs_copy(join_paths(source, name), join_paths(destination, name))
    end
  end
end

function M.execute_command(command)
  local handle = io.popen(command)
  if handle ~= nil then
    local result = handle:read("*a")
    result = string.gsub(result, "\n", "")
    handle:close()
    return result
  else
    return nil
  end
end

function M.register_envs(envs, change_env)
  _G.all3nvim.envs = envs
  _G.all3nvim.change_env = change_env
end

function M.get_project_root(root_patterns)
  root_patterns = root_patterns or { '.git', '.root', '.svn', '.hg' }
  local currentDir = vim.fn.expand('%:p:h')
  if string.match(currentDir, "^term:") ~= nil then
    return nil
  end
  while currentDir ~= '/' and currentDir ~= '' and currentDir ~= '.' do
    for _, pattern in ipairs(root_patterns) do
      local rootPath = currentDir .. '/' .. pattern
      if vim.fn.isdirectory(rootPath) == 1 or vim.fn.filereadable(rootPath) == 1 then
        return currentDir
      end
    end
    currentDir = vim.fn.fnamemodify(currentDir, ':h')
  end
  return nil
end

function M.get_project_name()
  -- local project_root = require("project_nvim.project").last_project
  local project_root = M.get_project_root(nil)
  if project_root then
    local separator = package.config:sub(1, 1)
    local basename = project_root:match("([^" .. separator .. "]+)$")
    return basename
  else
    return nil
  end
end

function M.envs()
  local envs = {
    VIM_FILEPATH = vim.fn.expand("%:p"),
    VIM_HOME = vim.fn.stdpath("config"),
    VIM_PATHNOEXT = vim.fn.expand("%:p:r"),
    VIM_FILENOEXT = vim.fn.expand("%:t:r"),
    VIM_FILENAME = vim.fn.expand("%:t"),
    VIM_FILEDIR = vim.fn.expand("%:p:h"),
    VIM_FILEEXT = vim.fn.expand("%:e"),
    VIM_CWD = vim.loop.cwd()
  }
  return envs
end

function M.mkdir_temp(prefix)
  local sys_tmp_dir = vim.loop.os_tmpdir()
  local tmp_dir = join_paths(sys_tmp_dir, prefix .. "XXXXXX")
  return vim.loop.fs_mkdtemp(tmp_dir)
end

function M.replace_vars(text, vars)
  local formattedString = text:gsub("%${(.-)}", function(match)
    return vars[match] or ""
  end)
  return formattedString
end

function M.remove_directory_recursive(path)
  local function remove_file_or_directory(itemPath)
    local stat = uv.fs_stat(itemPath)
    if stat then
      if stat.type == "directory" then
        M.remove_directory_recursive(itemPath) -- 递归删除子文件夹
        uv.fs_rmdir(itemPath)                  -- 删除空文件夹
        vim.notify("rm dir " .. itemPath)
      else
        uv.fs_unlink(itemPath) -- 删除文件
        vim.notify("rm " .. itemPath)
      end
    end
  end

  local dir = uv.fs_opendir(path)
  if dir then
    while true do
      local items = uv.fs_readdir(dir)
      vim.notify(path .. " items:" .. vim.inspect(items))
      if not items then break end
      for _, item in ipairs(items) do
        local itemPath = join_paths(path, item.name)
        remove_file_or_directory(itemPath)
      end
      remove_file_or_directory(path)
    end
    uv.fs_closedir(dir)
  end
end

return M
