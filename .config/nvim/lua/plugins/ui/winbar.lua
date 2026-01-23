vim.pack.add({
  {
    src = "https://github.com/SmiteshP/nvim-navic",
  },
  {
    src = "https://github.com/utilyre/barbecue.nvim",
  },
})

require("barbecue").setup({
  theme = "catppuccin",
  kinds = require("config.ui.icons"),
})
