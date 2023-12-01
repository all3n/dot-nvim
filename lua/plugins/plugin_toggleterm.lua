local M = {}
-- https://github.com/akinsho/toggleterm.nvim
M.direction = "horizontal"
M.size = 0.3

local python_cmd = function()
  if _G.all3nvim.python and _G.all3nvim.python.bin then
    return _G.all3nvim.python.bin
  else
    return "python"
  end
end
M.term_id_map = {}
M.last_id = nil
M.terms_map = {}
M.execs = {
  { nil,        "<C-T>",  "Horizontal Terminal", "horizontal", 0.3 },
  -- { nil,        "<C-\\>", "Float Terminal",      "float",      nil },
  { python_cmd, "<C-p>",  "Python",              "horizontal", 0.3 },
}
M.get_next_id = function()
  if M.last_id == nil then
    M.last_id = 1
  else
    M.last_id = M.last_id + 1
  end
  return M.last_id
end

local function get_buf_size()
  local cbuf = vim.api.nvim_get_current_buf()
  local bufinfo = vim.tbl_filter(function(buf)
    return buf.bufnr == cbuf
  end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
  if bufinfo == nil then
    return { width = -1, height = -1 }
  end
  return { width = bufinfo.width, height = bufinfo.height }
end
local function get_dynamic_terminal_size(direction, size)
  size = size or M.size
  if direction ~= "float" and tostring(size):find(".", 1, true) then
    size = math.min(size, 1.0)
    local buf_sizes = get_buf_size()
    local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
    return buf_size * size
  else
    return size
  end
end

M.add_exec = function(opts)
  -- local binary = opts.cmd:match "(%S+)"
  -- if vim.fn.executable(binary) ~= 1 then
  --   Log:debug("Skipping configuring executable " .. binary .. ". Please make sure it is installed properly.")
  --   return
  -- end

  vim.keymap.set({ "n", "t" }, opts.keymap, function()
    local real_cmd = opts.cmd
    if type(opts.cmd) == "function" then
      real_cmd = opts.cmd()
    end
    local term_count = opts.count
    if M.term_id_map[real_cmd] == nil then
      M.last_id = M.last_id + 1
      M.term_id_map[real_cmd] = M.last_id
    end
    -- vim.notify(real_cmd)
    M._exec_toggle { cmd = real_cmd, count = M.last_id, direction = opts.direction, size = opts.size() }
  end, { desc = opts.label, noremap = true, silent = true })
end

M._exec_toggle = function(opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new { cmd = opts.cmd, count = opts.count, direction = opts.direction }
  term:toggle(opts.size, opts.direction)
end



M.setup = function()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    close_on_exit = true,
    persist_size = true,
    -- direction = 'float',
  })
  for i, exec in pairs(M.execs) do
    local direction = exec[4] or M.direction
    local opts = {
      cmd = exec[1] or vim.o.shell,
      keymap = exec[2],
      label = exec[3],
      -- NOTE: unable to consistently bind id/count <= 9, see #2146
      count = i + 100,
      direction = direction,
      size = function()
        return get_dynamic_terminal_size(direction, exec[5])
      end,
    }
    if opts.cmd ~= vim.o.shell then
      M.last_id = opts.count
      M.term_id_map[opts.cmd] = M.last_id
    end
    M.add_exec(opts)
  end

  function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
end

M.get_cmd_idx = function(key)
  if M.term_id_map[key] ~= nil then
    return M.term_id_map[key]
  else
    M.term_id_map[key] = M.get_next_id()
    return M.term_id_map[key]
  end
end

M.lazygit_toggle = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = M.get_cmd_idx("lazygit"),
  }
  lazygit:toggle()
end

M.cmd_toggle = function(cmd, count)
  local count_idx = count or M.get_cmd_idx(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  local term_cmd = Terminal:new {
    cmd = cmd,
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = count_idx
  }
  term_cmd:toggle()
end

M.get_term = function(key, opts)
  local count_idx = M.get_cmd_idx(key)
  local term_cmd = M.terms_map[key]
  if term_cmd == nil then
    local Terminal = require("toggleterm.terminal").Terminal
    local default_opts = {
      hidden = true,
      direction = "horizontal",
      size = 0.3,
      on_close = function(_) end,
      count = count_idx,
    }
    if opts ~= nil then
      opts = vim.tbl_deep_extend("force", default_opts, opts)
    else
      opts = default_opts
    end
    term_cmd = Terminal:new(opts)
    M.terms_map[key] = term_cmd
    if not term_cmd:is_open() then
      term_cmd:open()
    end
  end
  return term_cmd
end





return M
