vim.pack.add({ {
  src = "https://github.com/kylechui/nvim-surround",
} })

require("nvim-surround").setup({
  keymaps = {
    normal = "gsa",
    normal_cur = "gss",
    normal_line = "gsS",
    visual = "gsa",
    delete = "gsd",
    change = "gsr",
  },
})
