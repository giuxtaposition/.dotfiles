--- Winbar rendering: assembles the filename and breadcrumb string.

local symbols = require("config.ui.winbar.symbols")
local ui_icons = require("config.ui.icons")

local M = {}

local separator = " %#WinBar_Separator#>%#WinBar# "

--- Map LSP SymbolKind number to a highlight group name and icon.
--- @param kind number
--- @return string icon, string hl_group
local function kind_icon(kind)
  local name = symbols.symbol_kind_names[kind] or "Variable"
  local icon = ui_icons.kinds[name] or ""
  local hl = "WinBar_Kind" .. name
  return icon, hl
end

--- Build the filename segment with devicons and modified indicator.
--- @param bufnr number
--- @return string
local function render_filename(bufnr)
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  if filename == "" then
    filename = "[No Name]"
  end

  local icon = ""
  local icon_hl = "WinBar"
  local devicons_present, devicons = pcall(require, "nvim-web-devicons")
  if devicons_present then
    local ext = vim.fn.fnamemodify(filename, ":e")
    local ft_icon, hl_group = devicons.get_icon(filename, ext, { default = true })
    if ft_icon then
      icon = ft_icon .. " "
    end
    if hl_group then
      icon_hl = hl_group
    end
  end

  local modified = vim.bo[bufnr].modified and " %#WinBar_Modified#●%#WinBar#" or ""

  return string.format("%%#%s#%s%%#WinBar#%s%s", icon_hl, icon, filename, modified)
end

--- Build the breadcrumb segment from cached LSP symbols.
--- @param bufnr number
--- @return string
local function render_breadcrumbs(bufnr)
  local crumbs = symbols.get_breadcrumbs(bufnr)
  if #crumbs == 0 then
    return ""
  end

  local parts = {}
  for _, crumb in ipairs(crumbs) do
    local icon, hl = kind_icon(crumb.kind)
    parts[#parts + 1] = string.format("%%#%s#%s %%#WinBar#%s", hl, icon, crumb.name)
  end

  return separator .. table.concat(parts, separator)
end

--- Truncate the rendered string if it exceeds available window width.
--- @param str string
--- @param max_width number
--- @return string
local function truncate(str, max_width)
  -- strdisplaywidth strips statusline %-sequences
  local display_len = vim.fn.strdisplaywidth(str:gsub("%%#[^#]*#", ""))
  if display_len <= max_width then
    return str
  end

  -- Rough truncation: trim breadcrumbs from the right
  local ellipsis = " %#WinBar_Separator#…%#WinBar#"
  -- Remove trailing crumb segments until it fits
  while display_len > max_width do
    local last_sep = str:find(">%%#WinBar#[^>]*$")
    if not last_sep then
      break
    end
    str = str:sub(1, last_sep - 3) .. ellipsis
    display_len = vim.fn.strdisplaywidth(str:gsub("%%#[^#]*#", ""))
  end

  return str
end

--- Render the full winbar string for the current window.
--- @return string
function M.render()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.bo[bufnr].buftype

  -- Skip special buffers
  if buftype ~= "" then
    return ""
  end

  local filename = render_filename(bufnr)
  local breadcrumbs = render_breadcrumbs(bufnr)
  local result = " " .. filename .. breadcrumbs

  local win_width = vim.api.nvim_win_get_width(0)
  return truncate(result, win_width - 2)
end

return M
