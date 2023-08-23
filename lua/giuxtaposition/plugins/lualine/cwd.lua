local M = require("lualine.component"):extend()
local utils = require("lualine.utils.utils")

local fn = vim.fn

M.init = function(self, options)
	M.super.init(self, options)
end

M.update_status = function()
	local dir_name = fn.fnamemodify(fn.getcwd(), ":t")
	local cwd = (vim.o.columns > 85 and dir_name) or ""
	return utils.stl_escape(cwd)
end

return M
