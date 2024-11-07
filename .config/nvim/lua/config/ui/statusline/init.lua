local utils = require("config.ui.statusline.utils")
local M = {}

function M.setup()
  vim.o.statusline = "%!v:lua.require'config.ui.statusline'.render()"
  M.namespace_id = vim.api.nvim_create_namespace("statusline")
  utils.set_highlights()
end

function M.render()
  local modules = require("config.ui.statusline.modules")

  return table.concat({
    modules.mode(),
    modules.file(),
    modules.diagnostics(),
    "%#StatusLine#%=",
    modules.typed_key(),
    modules.macro(),
    modules.lsp(),
    modules.git_branch(),
  })
end

return M
