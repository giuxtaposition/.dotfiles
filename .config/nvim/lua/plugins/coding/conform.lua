return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    format_on_save = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_fallback = true,
    },
    formatters_by_ft = {
      ["fish"] = { "fish_indent" },
      ["yaml"] = { "prettierd" },
    },
  },
}
