vim.lsp.enable({
  "phpactor",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "php" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "phpcbf" },
      },
    },
  },
}
