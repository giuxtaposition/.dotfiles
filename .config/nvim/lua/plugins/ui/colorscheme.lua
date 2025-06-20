return {
  {
    "giuxtaposition/andromeda",
    priority = 1000,
    config = function(_, opts)
      require("andromeda").setup()

      vim.cmd([[colorscheme andromeda]])
    end,
  },
}
