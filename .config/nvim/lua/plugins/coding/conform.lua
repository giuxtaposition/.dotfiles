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
      ["lua"] = { "stylua" },
      ["fish"] = { "fish_indent" },
      ["javascript"] = { "prettierd" },
      ["javascriptreact"] = { "prettierd" },
      ["typescript"] = { "prettierd" },
      ["typescriptreact"] = { "prettierd" },
      ["vue"] = { "prettierd" },
      ["css"] = { "prettierd" },
      ["scss"] = { "prettierd" },
      ["less"] = { "prettierd" },
      ["html"] = { "prettierd" },
      ["json"] = { "prettierd" },
      ["jsonc"] = { "prettierd" },
      ["yaml"] = { "prettierd" },
      ["markdown"] = { "prettierd" },
      ["markdown.mdx"] = { "prettierd" },
      ["svelte"] = { "prettierd" },
      ["sh"] = { "shfmt" },
      ["nix"] = { "alejandra" },
    },
  },
}
