local M = {}

function M.input()
  vim.ui.input({
    prompt = "test",
    default = ""
  }, function(input)
    if input then
      print("You entered " .. input)
    else
      print "You cancelled"
    end
  end)
end

return M
