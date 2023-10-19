local M = {}

function M.Map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	opts.noremap = opts.noremap ~= false

	vim.keymap.set(mode, lhs, rhs, opts)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	local Config = require("lazy.core.config")
	if Config.plugins[name] and Config.plugins[name]._.loaded then
		vim.schedule(function()
			fn(name)
		end)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

return M
