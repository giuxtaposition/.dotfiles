local colors = require("config.ui.colors")
local M = {
  delay = 100,
  timer = vim.uv.new_timer(),
  window_matches = {},
}

M.setup = function()
  M.create_autocommands()
  M.create_highlights()
end

M.create_autocommands = function()
  local gr = vim.api.nvim_create_augroup("CursorWordMatches", {})

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
  end

  au("CursorMoved", "*", M.auto_highlight, "Auto highlight cursor word matches")
  au({ "InsertEnter", "TermEnter", "QuitPre" }, "*", M.auto_unhighlight, "Auto unhighlight cursor word matches")
  au("ModeChanged", "*:[^i]", M.auto_highlight, "Auto highlight cursor word matches")
end

M.create_highlights = function()
  vim.api.nvim_set_hl(0, "CursorWordMatches", { bg = colors.surface0 })
end

M.auto_highlight = function()
  M.timer:stop()
  M.unhighlight()

  if M.is_cursor_on_keyword() then
    M.timer:start(
      M.delay,
      0,
      vim.schedule_wrap(function()
        M.unhighlight()
        M.highlight()
      end)
    )
  end
end

M.auto_unhighlight = function()
  M.timer:stop()
  M.unhighlight()
end

M.highlight = function()
  if not M.is_cursor_on_keyword() then
    return
  end

  local win_id = vim.api.nvim_get_current_win()

  M.window_matches[win_id] = M.window_matches[win_id] or {}
  if M.window_matches[win_id].id ~= nil then
    return
  end

  local current_word_pattern = [[\k*\%#\k*]]
  local curword = M.get_cursor_word()
  local pattern = string.format([[\(%s\)\@!\&\V\<%s\>]], current_word_pattern, curword)
  local match_id = vim.fn.matchadd("CursorWordMatches", pattern, -1)

  M.window_matches[win_id].id = match_id
end

M.unhighlight = function()
  local win_id = vim.api.nvim_get_current_win()
  local win_match = M.window_matches[win_id]
  if not vim.api.nvim_win_is_valid(win_id) or win_match == nil then
    return
  end

  pcall(vim.fn.matchdelete, win_match.id)
  M.window_matches[win_id] = nil
end

M.is_cursor_on_keyword = function()
  local col = vim.fn.col(".")
  local curchar = vim.api.nvim_get_current_line():sub(col, col)

  local ok, match_res = pcall(vim.fn.match, curchar, "[[:keyword:]]")
  return ok and match_res >= 0
end

M.get_cursor_word = function()
  return vim.fn.escape(vim.fn.expand("<cword>"), [[\/]])
end

return M
