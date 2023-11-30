local M = {}
local utils = require("utils")
local term = require("plugins.plugin_toggleterm")

local ExtHandler = {}
ExtHandler.__index = ExtHandler

function ExtHandler.new(ext, executor, sdk_home, build, cmd)
  local self = setmetatable({}, ExtHandler)
  self.envs = {}
  self.ext = ext
  self.executor = executor
  self.build = build
  self.cmd = cmd
  self.cmd_idx = nil
  self.sdk_home = sdk_home
  return self
end

function ExtHandler.__tostring(self)
  return self.ext
end

function ExtHandler.run_cmd(self, command, envs)
  -- local args = vim.tbl_extend("force", self.envs)
  local args = self.envs
  command = utils.replace_vars(command, args)
  self.term_cmd:send(command, true)
end

local function get_dependencies(h, file_path, visited)
  if not visited then
    visited = {}
  end
  local dependencies = {}
  local file = io.open(file_path, "r")
  if file then
    local content = file:read("*a")
    local pattern = '#include%s+"(.-)%.h"'
    for match in string.gmatch(content, pattern) do
      local dependency_file = match .. "." .. h.envs.VIM_FILEEXT
      if not visited[dependency_file] then
        visited[dependency_file] = true
        local sub_dependencies = get_dependencies(h, dependency_file, visited)
        for _, sub_dependency in ipairs(sub_dependencies) do
          table.insert(dependencies, sub_dependency)
        end
        table.insert(dependencies, dependency_file)
      end
    end
    file:close()
  end
  return dependencies
end

local function gxx_build(handler, file_path, build_dir)
  local dependencies = get_dependencies(handler, file_path, nil)
  local envs = handler.envs
  local bin_path = build_dir .. "/" .. envs.VIM_FILENOEXT
  local cmd = string.format("cd %s && %s -o %s %s %s", envs.VIM_FILEDIR, handler.executor, bin_path,
    envs.VIM_FILENAME, table.concat(dependencies, " "))
  handler.run_cmd(handler, cmd)
  handler.cmd = bin_path
end

local function parse_java_class(file_path)
  local file = io.open(file_path, "r")
  if file then
    local content = file:read("*a")
    local pattern = "class%s+(%w+)"
    local match = string.match(content, pattern)
    file:close()
    return match
  end
  return nil
end

local function java_build(handler, file_path, build_dir)
  local main_class = parse_java_class(file_path)
  if not main_class then
    error("can not find main class in " .. file_path)
  end
  local javac_bin = "javac"
  local java_bin = "java"
  if handler.sdk_home then
    java_bin = handler.sdk_home .. "/bin/java"
    javac_bin = handler.sdk_home .. "/bin/javac"
  end
  local build_cmd = string.format("%s -d %s %s", javac_bin, build_dir, file_path)
  handler.cmd = java_bin .. " -cp " .. build_dir .. " " .. main_class
  handler.run_cmd(handler, build_cmd)
end

local gcc = ExtHandler.new("c", os.getenv("CC") or "gcc", nil, gxx_build)
local gxx = ExtHandler.new("cpp", os.getenv("CXX") or "g++", nil, gxx_build)
local python = ExtHandler.new("python", os.getenv("PYTHON") or "python")
local java = ExtHandler.new("java", os.getenv("JAVA_HOME"), nil, java_build)

M.ext_handle = {
  c = gcc,
  cpp = gxx,
  cc = gxx,
  py = python,
  java = java,
  sh = ExtHandler.new("sh", "bash"),
  js = ExtHandler.new("js", "node"),
  go = ExtHandler.new("go", nil, nil, nil, "go run ${VIM_FILENAME}"),
  rs = ExtHandler.new("rust", nil, nil, nil, "rustc ${VIM_FILENAME} && ./${VIM_FILENOEXT}"),
  pl = ExtHandler.new("perl", "perl")
}

function M.execute(args)
  local envs = utils.envs()
  local file_path = envs.VIM_FILEPATH
  local file_dir = envs.VIM_FILEDIR
  local ext_name = envs.VIM_FILEEXT
  local file_no_ext = envs.VIM_FILENOEXT
  local file_name = envs.VIM_FILENAME
  local handler = M.ext_handle[ext_name]
  if not handler then
    vim.notify("not supported extension" .. ext_name)
    return -1
  end
  handler.envs = envs
  handler.term_cmd = term.get_term("build_term")
  if not handler.term_cmd:is_open() then
    handler.term_cmd:open()
  end
  handler.term_cmd:change_dir(file_dir, true)
  handler.term_cmd:send("clear", true)

  local build_dir = nil
  if handler.build then
    build_dir = utils.mkdir_temp("nvim_build_" .. file_no_ext)
    handler.envs["build_dir"] = build_dir
    handler.build(handler, file_path, build_dir)
  end

  local cmd = handler.cmd
  if not cmd and handler.executor then
    cmd = handler.executor .. " " .. file_path
  end
  if args then
    handler.run_cmd(handler, cmd .. " " .. args)
  else
    handler.run_cmd(handler, cmd)
  end
  if build_dir then
    -- utils.remove_directory_recursive(build_dir)
    handler.run_cmd(handler, "rm -rf " .. build_dir)
  end
end

return M
