local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- change color for arrows in tree
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#b4befe]])

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
					arrow_closed = "⮞", -- when folder is closed
					arrow_open = "⮟", -- when folder is open
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
