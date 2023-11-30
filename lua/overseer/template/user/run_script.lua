-- /home/stevearc/.config/nvim/lua/overseer/template/user/run_script.lua
return {
  name = "run_script",
  builder = function()
    local envs = require("tasks").envs()
    local bin_path = join_paths(envs.VIM_HOME, "bin", "run.sh")
    local cmd = { "bash", bin_path }
    return {
      cmd = cmd,
      env = envs,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end
}
