return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters.luacheck = {
      name = "luacheck",
      cmd = "luacheck",
      stdin = true,
      args = {
        "--globals",
        "vim",
        "lvim",
        "reload",
        "--",
      },
      stream = "stdout",
      ignore_exitcode = true,
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
        source = "luacheck",
      }),
    }

    lint.linters_by_ft = {
      lua = { "luacheck" },
      sh = { "shellcheck" },
      markdown = { "markdownlint" },
      javascript = {
        "eslint_d",
      },
      typescript = {
        "eslint_d",
      },
      javascriptreact = {
        "eslint_d",
      },
      typescriptreact = {
        "eslint_d",
      },
      svelte = { "eslint_d" },
      css = { "stylelint" },
      kotlin = { "ktlint" },
    }
  end,
  keys = {
    {
      "<leader>cl",
      function()
        require("lint").try_lint()
      end,
      { desc = "Trigger linting for current file" },
    },
  },
}
