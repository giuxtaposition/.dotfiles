local M = {}

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
---@param additional_opts? vim.keymap.set.Opts
M.set = function(mode, lhs, rhs, desc, additional_opts)
  local opts = vim.tbl_extend("force", { desc = desc, silent = true }, additional_opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
