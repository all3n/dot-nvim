return {
  name = "g++ build",
  builder = function()
    local envs = require("tasks").envs()
    local bin_path = join_paths(envs.VIM_HOME, "bin", "build2.sh")
    return {
      cmd = { "bash", bin_path },
      args = { envs.VIM_FILEPATH },
      env = envs,
      components = {
        -- { "on_output_quickfix", open = true }
        { "on_complete_notify", statuses = { "SUCCESS" } }
        , "default"
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
