vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
  },
})

require("conform").setup({
  format_on_save = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_fallback = true,
  },
  formatters_by_ft = {
    fish = { "fish_indent" },
    yaml = { "prettierd" },
    sh = { "shfmt" },
    go = { "gofumpt" },

    json = { "prettierd" },
    jsonc = { "prettierd" },

    lua = { "stylua" },
    markdown = { "prettierd" },
    ["markdown.mdx"] = { "prettierd" },
    nix = { "alejandra" },

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

    ruby = { "rubocop" },
    eruby = { "erb_format" },

    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    vue = { "prettierd" },
    css = { "prettierd" },
    scss = { "prettierd" },
    less = { "prettierd" },
    html = { "prettierd" },
    svelte = { "prettier" },
  },
})
