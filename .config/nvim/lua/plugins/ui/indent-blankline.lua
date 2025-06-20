return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "dashboard",
        "trouble",
        "lazy",
        "notify",
        "toggleterm",
      },
    },
  },
  main = "ibl",
}
