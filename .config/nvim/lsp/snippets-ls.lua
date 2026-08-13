-- In-process LSP that serves friendly-snippets as LSP completion items.
-- Native vim.lsp.completion expands insertTextFormat=Snippet via vim.snippet.

local protocol = vim.lsp.protocol
local METHODS = protocol.Methods
local ITEM_KIND = protocol.CompletionItemKind

local ROOT = vim.fn.stdpath("data") .. "/site/pack/core/opt/friendly-snippets"
local MAX_ITEMS = 200

local ft_files = nil ---@type table<string, string[]>|nil
local cache = {} ---@type table<string, lsp.CompletionItem[]>

local function read_json(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.json.decode, content, { luanil = { object = true } })
  return ok and decoded or nil
end

local function build_ft_files()
  local pkg = read_json(ROOT .. "/package.json")
  if not pkg or not pkg.contributes or not pkg.contributes.snippets then
    return {}
  end
  local map = {}
  for _, entry in ipairs(pkg.contributes.snippets) do
    local langs = type(entry.language) == "table" and entry.language or { entry.language }
    for _, lang in ipairs(langs) do
      if lang then
        map[lang] = map[lang] or {}
        table.insert(map[lang], ROOT .. "/" .. entry.path)
      end
    end
  end
  return map
end

local function normalize_body(body)
  if type(body) == "table" then
    return table.concat(body, "\n")
  end
  return body or ""
end

local function load_ft(ft)
  if cache[ft] then
    return cache[ft]
  end
  ft_files = ft_files or build_ft_files()
  local items = {}
  for _, file in ipairs(ft_files[ft] or {}) do
    local data = read_json(file)
    if data then
      for name, snip in pairs(data) do
        local prefixes = type(snip.prefix) == "table" and snip.prefix or { snip.prefix }
        local body = normalize_body(snip.body)
        for _, prefix in ipairs(prefixes) do
          if prefix and body ~= "" then
            table.insert(items, {
              label = prefix,
              kind = ITEM_KIND.Snippet,
              insertText = body,
              insertTextFormat = 2, -- Snippet
              detail = name,
              sortText = "zzz" .. prefix, -- rank below LSP items
              documentation = { kind = "markdown", value = "```\n" .. body .. "\n```" },
            })
            if #items >= MAX_ITEMS then
              cache[ft] = items
              return items
            end
          end
        end
      end
    end
  end
  cache[ft] = items
  return items
end

local function completion_items(params)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  if not bufnr or bufnr == -1 then
    return { isIncomplete = false, items = {} }
  end
  local ft = vim.bo[bufnr].filetype
  return { isIncomplete = false, items = load_ft(ft) }
end

---@param dispatchers vim.lsp.rpc.Dispatchers?
---@return vim.lsp.rpc.PublicClient
local function create_server(dispatchers)
  local closing = false
  local next_id = 0

  local function respond(method, params, callback)
    if method == METHODS.initialize then
      callback(nil, {
        capabilities = {
          textDocumentSync = protocol.TextDocumentSyncKind.None,
          completionProvider = { resolveProvider = false },
        },
        serverInfo = { name = "snippets-ls", version = "1.0.0" },
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
      next_id = next_id + 1
      respond(method, params, callback or function() end)
      return true, next_id
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

-- Detect supported filetypes eagerly so LSP only attaches where snippets exist.
ft_files = build_ft_files()

---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    return create_server(dispatchers)
  end,
  filetypes = vim.tbl_keys(ft_files),
  root_markers = { ".git" },
  workspace_required = false,
}
