local M = {
  hooks = {},
}

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

---@param count "prev" | "next"
M.jump_to_reference = function(count)
  return function()
    local params = vim.lsp.util.make_position_params(0, "utf-16")

    vim.lsp.buf_request(0, "textDocument/documentHighlight", params, function(err, result, _, _)
      if err or not result or vim.tbl_isempty(result) then
        print("No references found.")
        return
      end

      local current_pos = vim.api.nvim_win_get_cursor(0)
      local current_line = current_pos[1]
      local current_col = current_pos[2]

      table.sort(result, function(a, b)
        if a.range.start.line == b.range.start.line then
          return a.range.start.character < b.range.start.character
        else
          return a.range.start.line < b.range.start.line
        end
      end)

      local target = nil
      if count == "next" then
        for _, ref in ipairs(result) do
          local l = ref.range.start.line + 1
          local c = ref.range.start.character
          if l > current_line or (l == current_line and c > current_col) then
            target = { l, c }
            break
          end
        end
        if not target then
          local first = result[1].range.start
          target = { first.line + 1, first.character }
          print("Wrapped to first reference.")
        end
      elseif count == "prev" then
        for i = #result, 1, -1 do
          local ref = result[i]
          local l = ref.range.start.line + 1
          local c = ref.range.start.character
          if l < current_line or (l == current_line and c < current_col) then
            target = { l, c }
            break
          end
        end
        if not target then
          local last = result[#result].range.start
          target = { last.line + 1, last.character }
          print("Wrapped to last reference.")
        end
      else
        print("Invalid direction: " .. tostring(count))
        return
      end

      vim.api.nvim_win_set_cursor(0, target)
    end)
  end
end

M.restart_lsp = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients({ bufnr = bufnr })
  else
    ---@diagnostic disable-next-line: deprecated
    clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  end

  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end

  vim.defer_fn(function()
    vim.cmd("edit")
  end, 100)
end

M.lsp_status = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    print("󰅚 No LSP clients attached")
    return
  end

  print("󰒋 LSP Status for buffer " .. bufnr .. ":")
  print("─────────────────────────────────")

  for i, client in ipairs(clients) do
    print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
    print("  Root: " .. (client.config.root_dir or "N/A"))
    print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

    -- Check capabilities
    local caps = client.server_capabilities

    if caps == nil then
      print("  No capabilities reported")
      return
    end

    local features = {}
    if caps.completionProvider then
      table.insert(features, "completion")
    end
    if caps.hoverProvider then
      table.insert(features, "hover")
    end
    if caps.definitionProvider then
      table.insert(features, "definition")
    end
    if caps.referencesProvider then
      table.insert(features, "references")
    end
    if caps.renameProvider then
      table.insert(features, "rename")
    end
    if caps.codeActionProvider then
      table.insert(features, "code_action")
    end
    if caps.documentFormattingProvider then
      table.insert(features, "formatting")
    end

    print("  Features: " .. table.concat(features, ", "))
    print("")
  end
end

M.register_hook = function(fn)
  table.insert(M.hooks, fn)
end

M.run_hooks = function(client, bufnr)
  for _, hook in ipairs(M.hooks) do
    hook(client, bufnr)
  end
end

return M
