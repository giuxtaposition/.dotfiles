vim.lsp.enable({
  "jsonls",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "json5",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["json"] = { "prettierd" },
        ["jsonc"] = { "prettierd" },
      },
    },
  },
}
