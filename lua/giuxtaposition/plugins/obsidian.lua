return {
	"epwalsh/obsidian.nvim",
	lazy = true,
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Notes/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		completion = {
			nvim_cmp = true,
			min_chars = 2,
			new_notes_location = "current_dir",
			prepend_note_id = true,
		},
		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,
		mappings = {},
		finder = "telescope.nvim",
		sort_by = "modified",
		sort_reversed = true,
		open_notes_in = "current",
	},
}
