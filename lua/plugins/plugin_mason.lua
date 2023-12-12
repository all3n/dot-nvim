local M = {}
local mason_cfg = _G.all3nvim.mason


function M.auto_install()
  if mason_cfg ~= nil and mason_cfg.install ~= nil then
    local mason_registry = require("mason-registry")
    for _, v in ipairs(_G.all3nvim.mason.install) do
      if not mason_registry.is_installed(v) and mason_registry.has_package(v) then
        local pkg = mason_registry.get_package(v)
        vim.notify("Installing " .. v)
        pkg:install():once("closed", function()
          if pkg:is_installed() then
            vim.schedule(function()
              vim.notify("Installed " .. v .. " completed")
            end)
          end
        end)
      end
    end
  end
end

function M.setup()
  if _G.all3nvim.use_github_proxy then
    local github_download_url_template = "https://" ..
    _G.all3nvim.github_proxy .. "/https://github.com/%s/releases/download/%s/%s"
  else
    local github_download_url_template = "https://github.com/%s/releases/download/%s/%s"
  end

  require("mason").setup {
    github = {
      download_url_template = github_download_url_template,
    }
  }
  M.auto_install()
end

return M
