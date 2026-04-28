--- LSP document symbol fetching, caching, and cursor-position resolution.
--- Symbols are fetched asynchronously and cached per buffer.
--- Cache is invalidated on BufEnter, BufWritePost, and LspAttach.

local M = {}

--- @type table<number, lsp.DocumentSymbol[]> buf -> flat symbol tree
local cache = {}

--- @type table<number, boolean> buf -> request in-flight
local pending = {}

--- LSP SymbolKind enum (1-indexed, matching the spec)
M.symbol_kind_names = {
  [1] = "File",
  [2] = "Module",
  [3] = "Namespace",
  [4] = "Package",
  [5] = "Class",
  [6] = "Method",
  [7] = "Property",
  [8] = "Field",
  [9] = "Constructor",
  [10] = "Enum",
  [11] = "Interface",
  [12] = "Function",
  [13] = "Variable",
  [14] = "Constant",
  [15] = "String",
  [16] = "Number",
  [17] = "Boolean",
  [18] = "Array",
  [19] = "Object",
  [20] = "Key",
  [21] = "Null",
  [22] = "EnumMember",
  [23] = "Struct",
  [24] = "Event",
  [25] = "Operator",
  [26] = "TypeParameter",
}

--- Check whether cursor (0-indexed line, 0-indexed col) is inside a symbol range.
--- @param symbol lsp.DocumentSymbol
--- @param line number 0-indexed
--- @param col number 0-indexed
--- @return boolean
local function cursor_in_range(symbol, line, col)
  local range = symbol.range
  if not range then
    return false
  end

  local start_line = range.start.line
  local end_line = range["end"].line
  local start_col = range.start.character
  local end_col = range["end"].character

  if line < start_line or line > end_line then
    return false
  end
  if line == start_line and col < start_col then
    return false
  end
  if line == end_line and col > end_col then
    return false
  end

  return true
end

--- Recursively walk the symbol tree and collect the breadcrumb path for the cursor.
--- @param symbols lsp.DocumentSymbol[]
--- @param line number
--- @param col number
--- @param path table accumulator
--- @return table path of { name, kind } entries
local function resolve_path(symbols, line, col, path)
  for _, sym in ipairs(symbols) do
    if cursor_in_range(sym, line, col) then
      path[#path + 1] = { name = sym.name, kind = sym.kind }
      if sym.children and #sym.children > 0 then
        resolve_path(sym.children, line, col, path)
      end
      return path
    end
  end
  return path
end

--- Normalize SymbolInformation[] (flat with location) into DocumentSymbol[] (nested with range).
--- @param results table raw LSP result
--- @return lsp.DocumentSymbol[]
local function normalize_symbols(results)
  if not results or #results == 0 then
    return {}
  end

  -- Detect format: DocumentSymbol has `range`, SymbolInformation has `location`
  local first = results[1]
  if first.range then
    return results -- already DocumentSymbol format
  end

  -- Convert SymbolInformation -> flat DocumentSymbol-like entries
  local converted = {}
  for _, sym in ipairs(results) do
    if sym.location and sym.location.range then
      converted[#converted + 1] = {
        name = sym.name,
        kind = sym.kind,
        range = sym.location.range,
        children = {},
      }
    end
  end
  return converted
end

--- Request document symbols asynchronously from LSP for the given buffer.
--- Results are stored in cache. Skips if a request is already in-flight.
--- @param bufnr number
function M.fetch(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if pending[bufnr] then
    return
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentSymbol" })
  if #clients == 0 then
    cache[bufnr] = nil
    return
  end

  pending[bufnr] = true

  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result)
    pending[bufnr] = nil
    if err or not result then
      return
    end
    cache[bufnr] = normalize_symbols(result)
  end)
end

--- Invalidate cached symbols for a buffer.
--- @param bufnr number
function M.invalidate(bufnr)
  cache[bufnr] = nil
end

--- Get the breadcrumb path at the current cursor position for a buffer.
--- Returns an empty table if no symbols are cached.
--- @param bufnr number
--- @return table[] list of { name: string, kind: number }
function M.get_breadcrumbs(bufnr)
  local symbols = cache[bufnr]
  if not symbols then
    return {}
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1 -- convert to 0-indexed
  local col = cursor[2]

  return resolve_path(symbols, line, col, {})
end

--- Clean up cache for a deleted buffer.
--- @param bufnr number
function M.on_buf_delete(bufnr)
  cache[bufnr] = nil
  pending[bufnr] = nil
end

return M
