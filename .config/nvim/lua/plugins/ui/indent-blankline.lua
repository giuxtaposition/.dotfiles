return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy",
  -- For setting shiftwidth and tabstop automatically.
  dependencies = "tpope/vim-sleuth",
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
        "lazy",
      },
    },
  },
}
