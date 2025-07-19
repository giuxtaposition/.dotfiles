local table_util = require("config.util.table")

local MARK_GROUP = "Marks"
local MARK_HIGHLIGHT = "DiagnosticSignHint"
local MARK_PRIORITY = 100

local M = {
  mark_icons = {
    default = "",
    ["1"] = "󰲡",
    ["2"] = "󰲣",
    ["3"] = "󰲥",
    ["4"] = "󰲧",
    ["5"] = "󰲩",
    ["6"] = "󰲫",
    ["7"] = "󰲭",
    ["8"] = "󰲯",
    ["9"] = "󰲱",
  },
}

---@class MarkItem
---@field label string
---@field lnum integer
---@field col integer
---@field filename string

---@param mark string
local function mark2char(mark)
  if mark:match("[1-9]") then
    return string.char(mark + 64)
  end
  return mark
end

---@param char string
local function char2mark(char)
  if char:match("[A-I]") then
    return tostring(string.byte(char) - string.byte("A") + 1)
  end
  return char
end

---@param mark string
local function convert_to_integer(mark)
  local num = tonumber(mark)
  if not num then
    return 0
  end
  return math.floor(num)
end

---@param id integer
local function remove_sign(id)
  vim.fn.sign_unplace(MARK_GROUP, { id = id })
end

---@param mark string
---@param line_number integer
local function add_sign(mark, line_number)
  vim.fn.sign_define("Mark" .. mark, {
    text = M.mark_icons[mark] or M.mark_icons.default,
    texthl = MARK_HIGHLIGHT,
  })

  local int_num = convert_to_integer(mark)
  remove_sign(int_num) -- Remove existing sign with the same number
  vim.fn.sign_place(int_num, MARK_GROUP, "Mark" .. mark, vim.api.nvim_get_current_buf(), {
    lnum = line_number,
    priority = MARK_PRIORITY,
  })
end

---@param s string
local function strip_from_start_to_next_space(s)
  local space_pos = string.find(s, " ")
  if space_pos then
    return string.sub(s, 1, space_pos - 1)
  else
    return s
  end
end

---@param mark_entry table
---@param marks_items table
---@return table|nil
local function from_mark_entry_to_mark_item(mark_entry, marks_items)
  local icon = strip_from_start_to_next_space(mark_entry[1])
  for _, item in pairs(marks_items) do
    if item.label == table_util.get_key_by_value(M.mark_icons, icon) then
      return item
    end
  end
  return nil
end

---@return MarkItem[]
local function get_mark_items()
  local marks = vim.fn.getmarklist()

  ---@type MarkItem[]
  local marks_items = {}
  for _, mark in ipairs(marks) do
    local label = mark.mark:sub(2, 2)
    if label:match("^[A-I]$") then
      local transformed_label = char2mark(label)
      table.insert(marks_items, {
        label = transformed_label,
        lnum = mark.pos[2],
        col = mark.pos[3],
        filename = mark.file,
      })
    end
  end
  return marks_items
end

---@param current_buf integer
local function setup_signs(current_buf)
  local marks_items = get_mark_items()
  for _, mark in ipairs(marks_items) do
    local bufname = vim.api.nvim_buf_get_name(current_buf)
    local home = vim.loop.os_homedir()
    if not home then
      home = vim.fn.expand("~")
    end

    local bufshortname = bufname:gsub("^" .. vim.pesc(home), "~")
    if mark.filename == bufshortname then
      add_sign(mark.label, mark.lnum)
    end
  end
end

M.add_mark = function()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  vim.cmd("mark " .. char)
  if mark:match("[1-9]") then
    add_sign(mark, vim.api.nvim_win_get_cursor(0)[1])
  else
    vim.fn.feedkeys("m" .. mark, "n")
  end
end

M.remove_mark = function()
  local mark = vim.fn.getcharstr()
  vim.api.nvim_del_mark(mark2char(mark))
  if mark:match("[1-9]") then
    remove_sign(convert_to_integer(mark))
  end
end

M.remove_all_marks = function()
  vim.cmd("delmarks A-I")
  for mark, _ in pairs(M.mark_icons) do
    remove_sign(convert_to_integer(mark))
  end
end

M.goto_mark = function()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  local mark_pos = vim.api.nvim_get_mark(char, {})
  if mark_pos[1] == 0 then
    return vim.notify("No mark at " .. mark, vim.log.levels.WARN, { title = MARK_GROUP })
  end

  vim.fn.feedkeys("'" .. char, "n")
end

M.list_marks = function()
  local fzf = require("fzf-lua")
  local marks_items = get_mark_items()

  fzf.fzf_exec(
    vim.tbl_map(function(item)
      return fzf.make_entry.file(
        string.format(
          "%s %s",
          fzf.utils.ansi_codes.cyan(M.mark_icons[item.label] or M.mark_icons.default),
          item.filename
        )
      )
    end, marks_items),
    {
      prompt = M.mark_icons.default .. " > ",
      preview = {
        type = "cmd",
        fn = function(files)
          local item = from_mark_entry_to_mark_item(files, marks_items)

          if not item then
            return vim.notify("No mark found for " .. files[1], vim.log.levels.WARN, { title = MARK_GROUP })
          end

          return string.format("bat --style=default --line-range %s: --color=always %s", item.lnum, item.filename)
        end,
      },
      actions = {
        default = function(selected)
          local item = from_mark_entry_to_mark_item(selected, marks_items)

          if not item then
            return vim.notify("No mark found for " .. selected[1], vim.log.levels.WARN, { title = MARK_GROUP })
          end

          vim.cmd("edit " .. item.filename)
          vim.api.nvim_win_set_cursor(0, { item.lnum, item.col })
        end,
      },
    }
  )
end

vim.api.nvim_create_autocmd({ "BufNew" }, {
  group = vim.api.nvim_create_augroup("giuxtaposition-setup-marks-signs", { clear = true }),
  callback = function()
    setup_signs(vim.api.nvim_get_current_buf())
    vim.cmd("redraw")
  end,
})

return M
