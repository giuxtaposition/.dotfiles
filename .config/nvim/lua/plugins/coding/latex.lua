vim.pack.add({
  {
    src = "https://github.com/lervag/vimtex",
  },
})

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
vim.g.vimtex_quickfix_method = "pplatex"
