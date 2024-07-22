---@param file_name string
---@return nil or File
local function if_file_exists(file_name)
  if type(file_name) ~= "string" then
    return nil
  end

  local file = vim.fs.find(function(name, path)
    if path:match("node_modules") then
      return false
    end
    return name:match(file_name)
  end, { limit = 1, type = "file", path = "." })

  if file[1] ~= nil then
    return true
  else
    return false
  end
end

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

    if if_file_exists("eslint*") then
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end
  end,
  keys = {
    { "<leader>cl", ":lua require('lint').try_lint()<CR>", { desc = "Trigger linting for current file" } },
  },
}
