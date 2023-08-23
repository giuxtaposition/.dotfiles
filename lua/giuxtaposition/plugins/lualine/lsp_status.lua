local M = require("lualine.component"):extend()
local utils = require("lualine.utils.utils")

M.init = function(self, options)
	M.super.init(self, options)
	if not self.options.icon then
		self.options.icon = " "
	end
end

M.update_status = function(_)
	if rawget(vim, "lsp") then
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.name ~= "null-ls" then
				local lsp_status = (vim.o.columns > 100 and "LSP ~ " .. client.name .. " ") or "LSP "
				return utils.stl_escape(lsp_status)
			end
		end
	end
end

return M
