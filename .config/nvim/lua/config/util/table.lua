local M = {}

---@param tbl table
---@param f function
M.map = function(tbl, f)
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

return M
