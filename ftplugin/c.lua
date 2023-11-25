local utils = require("utils")
local c_env = "-"
local os_info = vim.loop.os_uname()
if os_info.sysname == "Windows" then
  c_env = "windows"
elseif os_info.sysname == "Linux" then
  local arch = utils.execute_command("uname -m")
  local compiler = "gcc"
  if vim.bo.filetype == "cpp" then
    compiler = "g++"
  end
  local cmd = compiler .. " -v 2>&1|tail -n 1|grep -E -o '[0-9\\.]+'|head -n 1"
  local gxx = utils.execute_command(cmd)
  _G.all3nvim.env = arch .. ":" .. compiler .. ":" .. gxx
elseif os_info.sysname == "Darwin" then
  local arch = utils.execute_command("uname -m")
  local compiler = "clang"
  if vim.bo.filetype == "cpp" then
    compiler = "clang++"
  end
  local cmd = compiler .. " -v 2>&1|head -n 1|awk '{print $NF}'|grep -o -E '[a-zA-Z0-9\\.\\-]+'|head -n 1"
  local gxx = utils.execute_command(cmd)
  _G.all3nvim.env = arch .. ":" .. compiler .. ":" .. gxx
end
