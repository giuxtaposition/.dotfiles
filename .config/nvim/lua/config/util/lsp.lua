local M = {}

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@param count "prev" | "next"
---@param severity? vim.diagnostic.SeverityFilter
M.diagnostic_go_to = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({
      count = count == "next" and 1 or -1,
      severity = severity,
      float = { border = "rounded", max_width = 100 },
    })
  end
end

return M
