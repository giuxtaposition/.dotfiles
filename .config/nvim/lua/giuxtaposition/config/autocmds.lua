local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Fix comment when inserting new line
-- autocmd({ "BufEnter", "BufWinEnter" }, {
--   group = augroup("comment_newline"),
--   pattern = { "*" },
--   callback = function()
--     vim.cmd([[set formatoptions-=cro]])
--   end,
-- })

-- Typescript: Remove unused imports on save
autocmd("BufWritePre", {
  group = augroup("unused_imports_on_save_typescript"),
  desc = "remove unused imports on save for typescript files",
  callback = function()
    local filetype = vim.bo.filetype
    if filetype == "typescript" or filetype == "typescriptreact" then
      vim.cmd("TSToolsRemoveUnusedImports")
    end
  end,
})

-- Typescript: Change tab width according to prettierrc
autocmd("BufEnter", {
  group = augroup("change_tab_width_typescript"),
  desc = "Change tab width following prettier config",
  pattern = { "*.ts, *.tsx" },
  callback = function()
    local file_exists = vim.fn.filereadable(".prettierrc")

    if file_exists == 1 then
      local tabWidth = vim.fn.json_decode(vim.fn.readfile(".prettierrc"))["tabWidth"]
      vim.bo.shiftwidth = tabWidth
    end
  end,
})
