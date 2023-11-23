local M = {}
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
    vim.notify("Directory created: " .. directory_path)
  end
end

function M.download_file(url, local_path)
  local success, error_message = vim.loop.fs_stat(local_path)
  if success ~= nil then
    return
  end
  local local_dir = vim.fn.fnamemodify(local_path, ":h")
  if vim.fn.isdirectory(local_dir) == 0 then
    local success, create_error = vim.loop.fs_mkdir(local_dir, 484) -- 484 is the default permission for directories
    if success == nil then
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

return M
