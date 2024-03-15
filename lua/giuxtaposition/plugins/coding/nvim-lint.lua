return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local linters = require("lint").linters

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

    -- use for codespell for all except css
    for ft, _ in pairs(lint.linters_by_ft) do
      if ft ~= "css" then
        table.insert(lint.linters_by_ft[ft], "codespell")
      end
    end

    linters.codespell.args = {
      "--builtin=rare,clear,informal,code,names,en-GB_to_en-US",
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      callback = function()
        if lint_status then
          lint.try_lint()
        end
      end,
    })
  end,
}
