local M = {}
local fcs = vim.opt.fillchars:get()

local function get_fold_without_numbers(lnum)
  if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
    return " "
  end
  return vim.fn.foldclosed(lnum) == -1 and fcs.foldopen or fcs.foldclose
end

function M.setup()
  vim.o.statuscolumn = "%!v:lua.require'config.ui.statuscolumn'.render()"
end

--- @return string
function M.render()
  return "%s  %2l " .. get_fold_without_numbers(vim.v.lnum) .. " "
end

return M
