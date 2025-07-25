vim.lsp.enable({
  "solargraph",
})

return {
  {
    "tpope/vim-rails",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ruby" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
        eruby = { "erb_format" },
      },
    },
  },
}
