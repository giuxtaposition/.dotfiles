local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- change color for arrows in tree
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#6c7086]])

nvimtree.setup({
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "", -- when folder is closed
					arrow_open = "", -- when folder is open
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
			quit_on_open = true,
		},
	},
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = false,
	},
})

-- fix not restoring nvim-tree with rmagatti/auto-session
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'NvimTree*',
  callback = function()
    local api = require('nvim-tree.api')
    local view = require('nvim-tree.view')

    if not view.is_visible() then
      api.tree.open()
    end
  end,
})
