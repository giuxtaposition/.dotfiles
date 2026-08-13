-- In-process LSP for i18n key completion.
-- Triggers inside: t('...'), t("..."), i18nKey='...', i18nKey={'...'}
-- Reads translations from config.i18n.

local protocol = vim.lsp.protocol
local METHODS = protocol.Methods
local ITEM_KIND = protocol.CompletionItemKind

local CONTEXT_PATTERNS = {
  "[^%w_]t%([\"'][%w%.%-_]*$",
  "^t%([\"'][%w%.%-_]*$",
  "i18nKey={?[\"'][%w%.%-_]*$",
}

local function in_i18n_context(before_cursor)
  for _, pat in ipairs(CONTEXT_PATTERNS) do
    if before_cursor:match(pat) then
      return true
    end
  end
  return false
end

local function get_line(uri, row)
  local bufnr = vim.uri_to_bufnr(uri)
  if not bufnr or bufnr == -1 or not vim.api.nvim_buf_is_loaded(bufnr) then
    return nil
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
  return lines and lines[1] or nil
end

local function completion_items(params)
  local pos = params.position
  local line = get_line(params.textDocument.uri, pos.line)
  if not line then
    return { isIncomplete = false, items = {} }
  end

  local byte_col = pos.character
  local before_cursor = line:sub(1, byte_col)
  if not in_i18n_context(before_cursor) then
    return { isIncomplete = false, items = {} }
  end

  local partial = before_cursor:match("[%w%.%-_]*$") or ""
  local translations = require("config.i18n")._.get_translations()
  local items = {}
  for key, val in pairs(translations) do
    table.insert(items, {
      label = key,
      kind = ITEM_KIND.Text,
      documentation = { kind = "plaintext", value = val },
      textEdit = {
        newText = key,
        range = {
          start = { line = pos.line, character = byte_col - #partial },
          ["end"] = { line = pos.line, character = byte_col },
        },
      },
    })
  end

  return { isIncomplete = false, items = items }
end

---@param dispatchers vim.lsp.rpc.Dispatchers?
---@return vim.lsp.rpc.PublicClient
local function create_server(dispatchers)
  local closing = false
  local next_request_id = 0

  local function respond(method, params, callback)
    if method == METHODS.initialize then
      callback(nil, {
        capabilities = {
          textDocumentSync = protocol.TextDocumentSyncKind.None,
          completionProvider = {
            triggerCharacters = { "'", '"', "." },
            resolveProvider = false,
          },
        },
        serverInfo = { name = "i18n-ls", version = "1.0.0" },
      })
      return
    end

    if method == METHODS.shutdown then
      closing = true
      callback(nil, nil)
      return
    end

    if method == METHODS.textDocument_completion then
      callback(nil, completion_items(params))
      return
    end

    callback(nil, nil)
  end

  return {
    request = function(method, params, callback)
      next_request_id = next_request_id + 1
      respond(method, params, callback or function() end)
      return true, next_request_id
    end,
    notify = function(method)
      if method == "exit" then
        closing = true
        if dispatchers and dispatchers.on_exit then
          dispatchers.on_exit(0, 0)
        end
      end
    end,
    is_closing = function()
      return closing
    end,
    terminate = function()
      closing = true
      if dispatchers and dispatchers.on_exit then
        dispatchers.on_exit(0, 15)
      end
    end,
  }
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    return create_server(dispatchers)
  end,
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = { "package.json", ".git" },
  workspace_required = false,
}
