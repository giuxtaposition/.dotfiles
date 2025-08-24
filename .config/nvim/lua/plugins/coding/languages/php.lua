vim.lsp.enable({
  "phpactor",
  "intelephense",
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
        php = {
          command = "php-cs-fixer",
          args = {
            "fix",
            "$FILENAME",
            "--config=/your/path/to/config/file/[filename].php",
            "--allow-risky=yes", -- if you have risky stuff in config, if not you dont need it.
          },
          stdin = false,
        },
      },
    },
  },
}
