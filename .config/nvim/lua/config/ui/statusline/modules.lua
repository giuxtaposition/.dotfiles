local utils = require("config.ui.statusline.utils")
local M = {}

M.mode = function()
  if not utils.is_active_win() then
    return ""
  end

  local modes = utils.modes
  local m = vim.api.nvim_get_mode().mode

  local current_mode = "%#StatusLine_" .. modes[m][2] .. "Mode#  " .. modes[m][1] .. " "
  return current_mode
end

M.file = function()
  local icon = utils.filetype_icon()
  return string.format("%%#StatusLine_FileIcon# %s %%#StatusLine_FileName#%%t", icon)
end

M.git_status = function()
  return utils.git_status()
end

M.diagnostics = function()
  local diagnostics = utils.diagnostics()

  local err = diagnostics.err and string.format("%%#StatusLine_DiagnosticsError#%s", diagnostics.err) or ""
  local warn = diagnostics.warn and string.format("%%#StatusLine_DiagnosticsWarning#%s", diagnostics.warn) or ""
  local hints = diagnostics.hints and string.format("%%#StatusLine_DiagnosticsHints#%s", diagnostics.hints) or ""
  local info = diagnostics.info and string.format("%%#StatusLine_DiagnosticsInfo#%s", diagnostics.info) or ""
  return err .. warn .. hints .. info
end

M.lsp = function()
  local lsp = utils.lsp()
  return lsp ~= "" and string.format("%%#StatusLine_LspInfo# %s", lsp) or ""
end

M.git_branch = function()
  local git_branch = utils.git_branch()
  return git_branch ~= "" and string.format(" %%#StatusLine_GitBranch# %s ", git_branch) or ""
end

M.macro = function()
  local macro = utils.macro()

  return macro ~= "" and string.format("%%#StatusLine_Macro# %s ", macro) or ""
end

M.typed_key = function()
  utils.record_typed_key()

  return utils.typed_key ~= "" and string.format("%%#StatusLine_TypedKey# %s ", utils.typed_key) or ""
end

return M
