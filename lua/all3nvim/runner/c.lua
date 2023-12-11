local M = {}

local c_sys_headers = {
  ["stdio.h"] = true,
  ["stdlib.h"] = true,
  ["stdbool.h"] = true,
  ["stddef.h"] = true,
  ["stdint.h"] = true,
  ["string.h"] = true,
  ["math.h"] = true,
  ["limits.h"] = true,
  ["float.h"] = true,
  ["stdarg.h"] = true,
  ["setjmp.h"] = true,
  ["signal.h"] = true,
  ["ctype.h"] = true,
  ["wchar.h"] = true,
  ["wctype.h"] = true,
  ["assert.h"] = true,
  ["errno.h"] = true,
  ["time.h"] = true,
  ["locale.h"] = true,
}

local cpp_sys_headers = {
  ["iostream"] = true,
  ["iomanip"] = true,
  ["fstream"] = true,
  ["cstdlib"] = true,
  ["cstring"] = true,
  ["cmath"] = true,
  ["cctype"] = true,
  ["cassert"] = true,
  ["cerrno"] = true,
  ["cstddef"] = true,
  ["cstdbool"] = true,
  ["csetjmp"] = true,
  ["csignal"] = true,
  ["clocale"] = true,
  ["cwchar"] = true,
  ["cwctype"] = true,
  ["cstdarg"] = true,
  ["ctime"] = true,
  ["locale"] = true,
  ["stdexcept"] = true,
  ["string"] = true,
  ["vector"] = true,
  ["algorithm"] = true,
  ["iterator"] = true,
  ["functional"] = true,
  ["utility"] = true,
  ["memory"] = true,
  ["typeinfo"] = true,
  ["new"] = true,
  ["tuple"] = true,
  ["random"] = true,
  ["regex"] = true,
  ["thread"] = true,
  ["mutex"] = true,
  ["condition_variable"] = true,
  ["atomic"] = true,
  ["chrono"] = true,
  ["ratio"] = true,
  ["filesystem"] = true
}





function M.get_dependencies(h, file_path, visited)
  if not visited then
    visited = {}
  end
  local dependencies = {}
  local sys_dependencies = {}
  local file = io.open(file_path, "r")
  if file then
    local content = file:read("*a")
    local pattern = '#include%s+"(.-)%.h"'
    local sys_pattern = '#include%s*<(.-)>'
    for match in string.gmatch(content, pattern) do
      local dependency_file = match .. "." .. h.envs.VIM_FILEEXT
      if not visited[dependency_file] then
        visited[dependency_file] = true
        local sub_dependencies, _ = M.get_dependencies(h, dependency_file, visited)
        for _, sub_dependency in ipairs(sub_dependencies) do
          table.insert(dependencies, sub_dependency)
        end
        table.insert(dependencies, dependency_file)
      end
    end

    for match in string.gmatch(content, sys_pattern) do
      table.insert(sys_dependencies, match)
    end
    file:close()
  end
  return dependencies, sys_dependencies
end

M.libraries = {
  ["uv.h"] = { "uv" }
}
local cxx = _G.all3nvim.cxx
M.search_paths = {
}
M.header_libs = {
  ["uv.h"] = { "uv" },
  ["json-c"] = { "json-c" },
  -- ["boost"] = { "boost"}
  ["SDL2"] = { "SDL2", "SDL2_image", "SDL2main" },
  ["mysql"] = { "mysqlclient" },
  ["openssl"] = { "openssl" },
  ["msgpack.h"] = { "msgpack" },
  ["microhttpd.h"] = { "microhttpd" },
  ["libssh2.h"] = { "ssh2" },
}
if cxx and cxx.search_paths then
  M.search_paths = vim.tbl_extend("force", M.search_paths, cxx.search_paths)
  local key_delete = {}
  for k, v in pairs(M.search_paths) do
    for idx, p in ipairs(v) do
      v[idx] = vim.api.nvim_call_function("expand", { p })
    end
    if k:match("~") then
      M.search_paths[vim.api.nvim_call_function("expand", { k })] = vim.deepcopy(v)
      table.insert(key_delete, k)
    end
  end
  for _, k in ipairs(key_delete) do
    M.search_paths[k] = nil
  end
end
if cxx and cxx.header_libs then
  M.header_libs = vim.tbl_extend("force", M.header_libs, cxx.header_libs)
end
local sysname = vim.loop.os_uname().sysname
if sysname == "Darwin" then
  M.search_paths["/opt/homebrew/include"] = { "/opt/homebrew/lib" }
elseif sysname == "Linux" then
  M.search_paths["/usr/local/include"] = { "/usr/local/lib64", "/usr/local/lib" }
  M.search_paths["/usr/include"] = { "/usr/lib64", "/usr/lib" }
elseif sysname:match("Windows") then
end
function M.detect_header(header, libs, includes, lib_paths)
  for header_include, lpaths in pairs(M.search_paths) do
    local stat = vim.loop.fs_stat(join_paths(header_include, header))
    if stat then
      if includes[header_include] == nil then
        table.insert(includes, header_include)
        if M.header_libs[header] then
          for _, lib in ipairs(M.header_libs[header]) do
            if libs[lib] == nil then
              table.insert(libs, lib)
            end
          end
        end
        if header:match("/") then
          header = string.match(header, "(.-)/")
          if M.header_libs[header] then
            for _, lib in ipairs(M.header_libs[header]) do
              if libs[lib] == nil then
                table.insert(libs, lib)
              end
            end
          end
        end
      end
      for _, lib_path in ipairs(lpaths) do
        if lib_paths[lib_path] == nil then
          table.insert(lib_paths, lib_path)
        end
      end
      return
    end
  end
end

function M.parse_lib_params(deps)
  local libs = {}
  local includes = {}
  local lib_paths = {}
  for _, dep in ipairs(deps) do
    if c_sys_headers[dep] == nil and cpp_sys_headers[dep] == nil then
      M.detect_header(dep, libs, includes, lib_paths)
    end
  end
  return libs, includes, lib_paths
end

function M.gxx_build(handler, file_path, build_dir)
  local dependencies, sys_dependencies = M.get_dependencies(handler, file_path, nil)
  local libs, includes, lib_paths = M.parse_lib_params(sys_dependencies)
  local cflags = ""
  for _, v in ipairs(includes) do
    cflags = cflags .. " -I" .. v .. " "
  end
  local ldflags = ""
  for _, v in ipairs(lib_paths) do
    ldflags = ldflags .. " -L" .. v .. " "
  end
  for _, v in ipairs(libs) do
    ldflags = ldflags .. " -l" .. v .. " "
  end
  local result = table.concat(libs, "-L")
  local envs = handler.envs
  local bin_path = build_dir .. "/" .. envs.VIM_FILENOEXT
  table.insert(handler.cmds, "cd " .. envs.VIM_FILEDIR)
  local build_cmd = string.format("%s %s -o %s %s %s %s", handler.executor, cflags, bin_path,
    envs.VIM_FILENAME, table.concat(dependencies, " "), ldflags)
  handler.add_cmd(handler, build_cmd)
  handler.cmd = bin_path
end

return M
