local M = {}

--- Filetypes whose markdown fence tag differs from the Neovim filetype name.
local fence_languages = {
  javascriptreact = "jsx",
  typescriptreact = "tsx",
  javascript = "js",
  typescript = "ts",
}

--- Yanks the current file's path relative to the cwd with the cursor line
--- appended as `#L<line>`, for pasting into reviews, issues or chats.
function M.yank_path_with_line()
  local path = ("%s#L%d"):format(vim.fn.expand("%:."), vim.fn.line("."))
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end

--- Copies the last visual selection as a markdown code block tagged with the
--- filetype, the path relative to the cwd and the starting line.
function M.copy_as_codeblock()
  local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
  if vim.api.nvim_buf_get_name(0) == "" then
    vim.notify("Buffer has no file name", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local language = fence_languages[vim.bo.filetype] or vim.bo.filetype
  local fence = ('```%s filename="%s" line=%d'):format(language, vim.fn.expand("%:."), start_line)

  vim.fn.setreg("+", table.concat(vim.iter({ fence, lines, "```" }):flatten():totable(), "\n"))
  vim.notify(("Copied %d lines as codeblock"):format(#lines))
end

return M
