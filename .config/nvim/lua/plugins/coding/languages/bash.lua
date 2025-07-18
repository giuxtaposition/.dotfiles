vim.lsp.enable({
  "bashls",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = {
      "bash",
    } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["sh"] = { "shfmt" },
      },
    },
  },
}
