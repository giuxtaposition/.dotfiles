return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      padding = { 1, 0, 1, 2 },
      wo = {
        winblend = 5, -- opaque
      },
    },
    layout = {
      height = { min = 3, max = 25 },
      width = { min = 20, max = 100 },
      spacing = 5, -- spacing between columns
      align = "center",
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)
    require("which-key").add({
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      { "]", group = "next" },
      { "[", group = "prev" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "test" },
      { "<leader>w", group = "windows" },
      { "<leader>x", group = "diagnostics/quickfix" },
    })
  end,
}
