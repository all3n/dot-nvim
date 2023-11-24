local M = {}
function M.setup()
  require('browse').setup({
    provider = "google",
    bookmarks = {
      ["cpp_reference"] = "https://www.google.com/search?as_q=%s&as_sitesearch=cppreference.com",
      ["github"] = {
        ["name"] = "Github",
        ["github_code_search"] = "https://github.com/search?q=%s&type=code",
        ["github_repo_search"] = "https://github.com/search?q=%s&type=repositories",
      },
      ["bing"] = "https://cn.bing.com/search?q=%s"
    },
  })
end

return M
