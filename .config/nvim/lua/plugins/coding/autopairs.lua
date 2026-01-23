vim.pack.add({
  {
    src = "https://github.com/windwp/nvim-autopairs",
  },
})

require("nvim-autopairs").setup({
  disable_in_macro = false,
})
