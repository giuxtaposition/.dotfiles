-- blink.cmp completion source for i18n keys.
-- Triggers inside: t('...'), t("..."), i18nKey='...', i18nKey={'...'}, etc.

local source = {}

-- Mirror the patterns used in i18n.lua, but allow a partial (possibly empty) key at the end
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

function source.new()
  return setmetatable({}, { __index = source })
end

function source:get_completions(ctx, callback)
  -- cursor_before_line is not provided by blink.cmp v1; derive it manually
  local before_cursor = ctx.line:sub(1, ctx.cursor[2])

  if not in_i18n_context(before_cursor) then
    callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
    return
  end

  -- Derive the partial key already typed so we can replace it precisely
  local partial = before_cursor:match("[%w%.%-_]*$") or ""
  local col = ctx.cursor[2] -- 0-indexed byte offset

  local translations = require("config.i18n")._.get_translations()
  local items = {}
  for key, val in pairs(translations) do
    table.insert(items, {
      label = key,
      kind = vim.lsp.protocol.CompletionItemKind.Text,
      documentation = { kind = "plaintext", value = val },
      -- Replace the partial key already typed with the full key
      textEdit = {
        newText = key,
        range = {
          start = { line = ctx.cursor[1] - 1, character = col - #partial },
          ["end"] = { line = ctx.cursor[1] - 1, character = col },
        },
      },
    })
  end

  callback({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
  })
end

return source
