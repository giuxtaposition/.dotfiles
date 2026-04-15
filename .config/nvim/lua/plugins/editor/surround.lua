vim.pack.add({ {
  src = "https://github.com/kylechui/nvim-surround",
} })

require("nvim-surround").setup()
-- Default keymaps
-- <C-g>s Add a surrounding pair around the cursor (insert mode)
vim.keymap.set("n", "gsa", "<Plug>(nvim-surround-normal)", {
  desc = "Add a surrounding pair around a motion (normal mode)",
})
vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", {
  desc = "Delete a surrounding pair",
})
vim.keymap.set("n", "gsr", "<Plug>(nvim-surround-change)", {
  desc = "Change a surrounding pair",
})
vim.keymap.set("x", "gsa", "<Plug>(nvim-surround-visual)", {
  desc = "Add a surrounding pair around a visual selection",
})
