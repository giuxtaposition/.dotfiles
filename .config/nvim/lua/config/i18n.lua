local M = {}

local config = {
  translation_file = "public/locales/it/translation.json",
  hl_group = "Comment",
  virt_text_prefix = "  ",
  max_display_len = 100,
}

local translations = {}
local ns = vim.api.nvim_create_namespace("i18n_inline")
local diag_ns = vim.api.nvim_create_namespace("i18n_diagnostics")
local enabled = true

local PREFIX = "i18n_inline"
local function notify(msg, level)
  vim.notify(PREFIX .. ": " .. msg, level)
end

-- Flatten nested table into dot-separated keys: { "a.b.c" = "value" }
local function flatten(tbl, prefix, result)
  result = result or {}
  prefix = prefix or ""
  for k, v in pairs(tbl) do
    local key = prefix == "" and k or (prefix .. "." .. k)
    if type(v) == "table" then
      flatten(v, key, result)
    else
      result[key] = tostring(v)
    end
  end
  return result
end

-- Walk upward from the current file to find the project root (package.json)
local function find_root()
  local markers = vim.fs.find("package.json", {
    path = vim.fn.expand("%:p:h"),
    upward = true,
    limit = 1,
  })
  if markers[1] then
    return vim.fn.fnamemodify(markers[1], ":h")
  end
  return vim.fn.getcwd()
end

local function load_translations()
  local root = find_root()
  local filepath = root .. "/" .. config.translation_file
  local f = io.open(filepath, "r")
  if not f then
    notify("could not open " .. filepath, vim.log.levels.WARN)
    return
  end
  local content = f:read("*a")
  f:close()
  local ok, parsed = pcall(vim.fn.json_decode, content)
  if ok and type(parsed) == "table" then
    translations = flatten(parsed)
  else
    notify("failed to parse translation file", vim.log.levels.ERROR)
  end
end

local function truncate(val)
  val = val:gsub("\n", " ")
  if #val > config.max_display_len then
    return val:sub(1, config.max_display_len) .. "…"
  end
  return val
end

-- Patterns capture the key portion from supported i18n call forms:
--   t('key') / t("key")
--   i18nKey='key' / i18nKey="key" / i18nKey={'key'} / i18nKey={"key"}
local PATTERNS = {
  "%f[%w_]t%([\"']([%w%.%-_]+)[\"']",
  "i18nKey={?[\"']([%w%.%-_]+)[\"']",
}

-- Returns all i18n key matches on a line with their positions:
--   s/e  = 1-indexed start/end of the full match  (e.g. the whole t('some.key'))
--   ks/ke = 1-indexed start/end of the key itself (e.g. some.key)
local function find_keys_on_line(line)
  local matches = {}
  for _, pat in ipairs(PATTERNS) do
    local col = 1
    while true do
      local s, e, key = line:find(pat, col)
      if not s then
        break
      end
      local ks = line:find(key, s, true)
      table.insert(matches, { s = s, e = e, ks = ks, ke = ks + #key - 1, key = key })
      col = e + 1
    end
  end
  return matches
end

-- Hard-wrap text at `width` chars, splitting on existing newlines first
local function wrap(text, width)
  local result = {}
  for segment in (text .. "\n"):gmatch("([^\n]*)\n") do
    while #segment > width do
      table.insert(result, segment:sub(1, width))
      segment = segment:sub(width + 1)
    end
    table.insert(result, segment)
  end
  return result
end

-- Build the content lines and compute window width for the popup
local function build_popup_lines(key, val, max_width)
  local val_prefix = "Value: "
  local val_indent = string.rep(" ", #val_prefix)
  local lines = { "Key:   " .. key }
  for i, seg in ipairs(wrap(val, max_width - #val_prefix)) do
    table.insert(lines, (i == 1 and val_prefix or val_indent) .. seg)
  end
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end
  return lines, width
end

local function update_virtual_text(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  if not enabled or vim.tbl_isempty(translations) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for lnum, line in ipairs(lines) do
    -- Track rightmost match per line to avoid duplicate EOL marks
    local last_col, last_virt = nil, nil
    for _, m in ipairs(find_keys_on_line(line)) do
      local val = translations[m.key]
      if val and (not last_col or m.e > last_col) then
        last_col = m.e
        last_virt = config.virt_text_prefix .. truncate(val)
      end
    end
    if last_col then
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, last_col - 1, {
        virt_text = { { last_virt, config.hl_group } },
        virt_text_pos = "eol",
        hl_mode = "combine",
      })
    end
  end
end

local function update_diagnostics(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if vim.tbl_isempty(translations) then
    vim.diagnostic.set(diag_ns, bufnr, {})
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local diagnostics = {}

  for lnum, line in ipairs(lines) do
    for _, m in ipairs(find_keys_on_line(line)) do
      if not translations[m.key] then
        table.insert(diagnostics, {
          lnum = lnum - 1,
          col = m.ks - 1, -- 0-indexed, highlights the key text only
          end_col = m.ke,
          severity = vim.diagnostic.severity.WARN,
          message = 'Missing i18n key: "' .. m.key .. '"',
          source = PREFIX,
        })
      end
    end
  end

  vim.diagnostic.set(diag_ns, bufnr, diagnostics)
end

local function refresh(bufnr)
  update_virtual_text(bufnr)
  update_diagnostics(bufnr)
end

-- Find the i18n key at the cursor column on the current line
local function key_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] -- 0-indexed
  -- s/e are 1-indexed; cursor_col is 0-indexed → compare as 0-indexed
  for _, m in ipairs(find_keys_on_line(line)) do
    if cursor_col >= m.s - 1 and cursor_col <= m.e - 1 then
      return m.key
    end
  end
  return nil
end

-- Show a floating window with the key and its full value
function M.show_popup()
  local key = key_at_cursor()
  if not key then
    notify("no key at cursor", vim.log.levels.INFO)
    return
  end
  local val = translations[key]
  if not val then
    notify("key not found: " .. key, vim.log.levels.WARN)
    return
  end

  local lines, width = build_popup_lines(key, val, 88)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = #lines,
    style = "minimal",
    border = "rounded",
  })

  -- Auto-close on cursor move
  vim.api.nvim_create_autocmd("CursorMoved", {
    once = true,
    callback = function()
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end,
  })
end

-- Open the translation JSON and jump to the last segment of the key
function M.goto_definition()
  local key = key_at_cursor()
  if not key then
    notify("no key at cursor", vim.log.levels.INFO)
    return
  end

  local root = find_root()
  local filepath = root .. "/" .. config.translation_file
  local segments = vim.split(key, "%.")
  local last_segment = segments[#segments]

  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
  -- Search forward (wrapping) for the JSON key
  local found = vim.fn.search('"' .. last_segment .. '"', "w")
  if found == 0 then
    notify('could not locate "' .. last_segment .. '" in file', vim.log.levels.WARN)
  end
end

-- Toggle virtual text on/off for the current buffer
function M.toggle()
  enabled = not enabled
  if enabled then
    refresh()
    notify("on", vim.log.levels.INFO)
  else
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    notify("off", vim.log.levels.INFO)
  end
end

local JS_FT = { typescript = true, typescriptreact = true, javascript = true, javascriptreact = true }

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  load_translations()

  local augroup = vim.api.nvim_create_augroup("I18nInline", { clear = true })

  -- Refresh virtual text and diagnostics on buffer events
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = augroup,
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
    callback = function(ev)
      refresh(ev.buf)
    end,
  })

  -- Reload translations when the JSON file is saved
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    pattern = "*/public/locales/it/translation.json",
    callback = function()
      load_translations()
      refresh()
    end,
  })

  -- Override K (hover) and grd (definition) for JS/TS buffers.
  -- When cursor is on an i18n key, use i18n actions; otherwise fall back to LSP.
  -- Set on LspAttach so our maps run after neovim's default LSP maps are installed.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      if not JS_FT[vim.bo[ev.buf].filetype] then
        return
      end
      -- Guard: only install once per buffer (LspAttach fires per client)
      if vim.b[ev.buf].i18n_keymaps_set then
        return
      end
      vim.b[ev.buf].i18n_keymaps_set = true

      vim.keymap.set("n", "K", function()
        if key_at_cursor() then
          M.show_popup()
        else
          vim.lsp.buf.hover()
        end
      end, { buffer = ev.buf, desc = "i18n popup or LSP hover" })

      vim.keymap.set("n", "grd", function()
        if key_at_cursor() then
          M.goto_definition()
        else
          vim.lsp.buf.definition()
        end
      end, { buffer = ev.buf, desc = "i18n definition or LSP definition" })
    end,
  })
end

-- Expose pure internals for testing and the completion source
M._ = {
  flatten = flatten,
  find_keys_on_line = find_keys_on_line,
  wrap = wrap,
  build_popup_lines = build_popup_lines,
  get_translations = function()
    return translations
  end,
}

return M
