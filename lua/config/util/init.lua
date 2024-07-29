local M = {
  lsp = require("config.util.lsp"),
}

function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  opts.noremap = opts.noremap ~= false

  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
