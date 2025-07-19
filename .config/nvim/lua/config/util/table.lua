local M = {}

---@param tbl table
---@param value any
M.get_key_by_value = function(tbl, value)
  for k, v in pairs(tbl) do
    if v == value then
      return k
    end
  end
  return nil
end

return M
