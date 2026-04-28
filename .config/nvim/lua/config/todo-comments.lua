local colors = require("config.ui.colors")

local M = {}

local HIGHLIGHT_PRIORITY = 200
local HIGHLIGHT_PREFIX = "TodoComment"

local defaults = {
  keywords = {
    TODO = { color = colors.sky, icon = " " },
    FIX = { color = colors.red, icon = " ", alt = { "FIXME", "BUG", "ISSUE" } },
    NOTE = { color = colors.green, icon = " ", alt = { "INFO" } },
    WARN = { color = colors.peach, icon = " ", alt = { "WARNING" } },
  },
  comment_prefixes = { "^%s*//", "^%s*#", "^%s*%-%-", "^%s*/%*", "^%s*;", '^%s*"""', "^%s*'''" },
}

local config = {}
--- Maps every keyword and alt to its canonical name (e.g. "FIXME" -> "FIX")
---@type table<string, string>
local keyword_lookup = {}
--- Sorted keyword list (longest first), cached after setup
---@type string[]
local sorted_keywords = {}
local ns_id
local qf_ns_id

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Keyword lookup
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

---@return string canonical name for keyword, or nil
local function resolve_keyword(word)
  return keyword_lookup[word]
end

local function rebuild_keyword_cache()
  keyword_lookup = {}
  for name, kw in pairs(config.keywords) do
    keyword_lookup[name] = name
    for _, alt in ipairs(kw.alt or {}) do
      keyword_lookup[alt] = name
    end
  end

  sorted_keywords = vim.tbl_keys(keyword_lookup)
  table.sort(sorted_keywords, function(a, b)
    return #a > #b
  end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Highlights
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local function hl_group(canonical)
  return HIGHLIGHT_PREFIX .. canonical
end

local function create_highlights()
  for name, kw in pairs(config.keywords) do
    vim.api.nvim_set_hl(0, hl_group(name), { fg = colors.crust, bg = kw.color, bold = true })
    vim.api.nvim_set_hl(0, hl_group(name) .. "Text", { fg = kw.color })
  end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Comment detection
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

---@param bufnr number
---@param row number 0-indexed
---@param col number 0-indexed
---@return boolean
local function is_comment_treesitter(bufnr, row, col)
  local node = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, col } })
  while node do
    if node:type():find("comment") then
      return true
    end
    node = node:parent()
  end
  return false
end

---@param line string
---@param col number 1-indexed column of keyword start
---@return boolean
local function is_comment_regex(line, col)
  local before = line:sub(1, col - 1)
  for _, prefix in ipairs(config.comment_prefixes) do
    if before:match(prefix) then
      return true
    end
  end
  return false
end

---@param bufnr number
---@param row number 0-indexed
---@param col number 0-indexed
---@param line string
---@return boolean
local function is_comment(bufnr, row, col, line)
  local has_parser = pcall(vim.treesitter.get_parser, bufnr, nil, { error = false })
  if has_parser then
    return is_comment_treesitter(bufnr, row, col)
  end
  return is_comment_regex(line, col + 1)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Match finding
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

--- Find first keyword match in a line
---@param line string
---@return string|nil keyword
---@return number|nil col_start 1-indexed
---@return number|nil col_end 1-indexed
local function find_keyword_in_line(line)
  for _, kw in ipairs(sorted_keywords) do
    local col_start, col_end = line:find("%f[%w]" .. kw .. "%f[%W]")
    if not col_start then
      goto continue
    end

    local after = line:sub(col_end + 1, col_end + 1)
    if after == ":" or after == " " or after == "" then
      return kw, col_start, col_end
    end

    ::continue::
  end
  return nil
end

---@class TodoMatch
---@field row number 0-indexed
---@field col number 0-indexed
---@field col_end number 1-indexed (exclusive)
---@field keyword string matched keyword
---@field canonical string canonical keyword name
---@field line string full line text

---@param bufnr number
---@return TodoMatch[]
local function find_buffer_matches(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local matches = {}

  for row_1indexed, line in ipairs(lines) do
    local kw, col_start, col_end = find_keyword_in_line(line)
    if not kw then
      goto continue
    end

    local row = row_1indexed - 1
    if not is_comment(bufnr, row, col_start - 1, line) then
      goto continue
    end

    matches[#matches + 1] = {
      row = row,
      col = col_start - 1,
      col_end = col_end,
      keyword = kw,
      canonical = resolve_keyword(kw),
      line = line,
    }

    ::continue::
  end

  return matches
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Buffer highlighting
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

---@param bufnr number
---@param match TodoMatch
local function apply_match_extmarks(bufnr, match)
  local group = hl_group(match.canonical)
  local icon = config.keywords[match.canonical].icon or ""

  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, match.row, match.col, {
    end_col = match.col_end,
    hl_group = group,
    priority = HIGHLIGHT_PRIORITY,
  })

  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, match.row, match.col, {
    virt_text = { { icon, group } },
    virt_text_pos = "inline",
    priority = HIGHLIGHT_PRIORITY,
  })
end

---@param bufnr number
local function highlight_buffer(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  for _, match in ipairs(find_buffer_matches(bufnr)) do
    apply_match_extmarks(bufnr, match)
  end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Navigation
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

---@param match TodoMatch
local function jump_to_match(match)
  vim.api.nvim_win_set_cursor(0, { match.row + 1, match.col })
end

---@param matches TodoMatch[]
---@param cur_row number 0-indexed
---@param cur_col number 0-indexed
---@return TodoMatch|nil
local function find_next_match(matches, cur_row, cur_col)
  for _, m in ipairs(matches) do
    if m.row > cur_row or (m.row == cur_row and m.col > cur_col) then
      return m
    end
  end
  return matches[1] -- wrap around
end

---@param matches TodoMatch[]
---@param cur_row number 0-indexed
---@param cur_col number 0-indexed
---@return TodoMatch|nil
local function find_prev_match(matches, cur_row, cur_col)
  for i = #matches, 1, -1 do
    local m = matches[i]
    if m.row < cur_row or (m.row == cur_row and m.col < cur_col) then
      return m
    end
  end
  return matches[#matches] -- wrap around
end

---@param direction number 1 for next, -1 for previous
function M.jump(direction)
  local matches = find_buffer_matches(vim.api.nvim_get_current_buf())
  if #matches == 0 then
    vim.notify("No TODO comments found", vim.log.levels.INFO)
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cur_row, cur_col = cursor[1] - 1, cursor[2]

  local finder = direction == 1 and find_next_match or find_prev_match
  local target = finder(matches, cur_row, cur_col)
  if target then
    jump_to_match(target)
  end
end

function M.next()
  M.jump(1)
end

function M.prev()
  M.jump(-1)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Quickfix
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

---@param stdout string
---@return table[] quickfix items
local function parse_ripgrep_output(stdout)
  local items = {}

  for line in stdout:gmatch("[^\n]+") do
    local file, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
    if not file then
      goto continue
    end

    local kw = find_keyword_in_line(text)
    items[#items + 1] = {
      filename = file,
      lnum = tonumber(lnum),
      col = tonumber(col),
      text = (kw or "TODO") .. ": " .. vim.trim(text),
    }

    ::continue::
  end

  return items
end

local function highlight_quickfix_buffer()
  local qf_buf = vim.fn.getqflist({ qfbufnr = 0 }).qfbufnr
  if not qf_buf or qf_buf == 0 then
    return
  end

  vim.api.nvim_buf_clear_namespace(qf_buf, qf_ns_id, 0, -1)

  for row, line in ipairs(vim.api.nvim_buf_get_lines(qf_buf, 0, -1, false)) do
    local kw = find_keyword_in_line(line)
    if not kw then
      goto continue
    end

    local col_start, col_end = line:find("%f[%w]" .. kw .. "%f[%W]")
    if col_start then
      pcall(vim.api.nvim_buf_set_extmark, qf_buf, qf_ns_id, row - 1, col_start - 1, {
        end_col = col_end,
        hl_group = hl_group(resolve_keyword(kw)),
        priority = HIGHLIGHT_PRIORITY,
      })
    end

    ::continue::
  end
end

---@param result vim.SystemCompleted
local function on_ripgrep_complete(result)
  if result.code ~= 0 and result.code ~= 1 then
    vim.notify("ripgrep failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
    return
  end

  local items = parse_ripgrep_output(result.stdout or "")
  if #items == 0 then
    vim.notify("No TODO comments found in project", vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, "r", { title = "TODO Comments (project)", items = items })
  vim.cmd("copen")
  highlight_quickfix_buffer()
end

function M.quickfix()
  local pattern = [[\b(]] .. table.concat(sorted_keywords, "|") .. [[)\b\s*:?]]
  local cmd = { "rg", "--vimgrep", "--no-heading", "-e", pattern, vim.fn.getcwd() }
  vim.system(cmd, { text = true }, vim.schedule_wrap(on_ripgrep_complete))
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Setup
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})

  rebuild_keyword_cache()
  ns_id = vim.api.nvim_create_namespace("todo_comments")
  qf_ns_id = vim.api.nvim_create_namespace("todo_comments_qf")
  create_highlights()

  local group = vim.api.nvim_create_augroup("giuxtaposition_todo_comments", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
    group = group,
    desc = "Highlight TODO comments",
    callback = function(ev)
      highlight_buffer(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    desc = "Re-create TODO comment highlights on colorscheme change",
    callback = create_highlights,
  })
end

return M
