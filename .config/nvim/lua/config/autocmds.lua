local function augroup(name)
  return vim.api.nvim_create_augroup("giuxtaposition_" .. name, { clear = true })
end

-- check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  desc = "Go to the last location when opening a buffer",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup("highlight_on_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "lspinfo",
    "qf",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "neotest-output",
    "fugitive",
    "fugitiveblame",
    "git",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Typescript: Change tab width according to prettierrc
vim.api.nvim_create_autocmd("BufEnter", {
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

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("keymap_filetype"),
  desc = "Set filetype to c for keymap files",
  pattern = "*.keymap",
  callback = function()
    vim.bo.filetype = "c"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("big_file"),
  desc = "Disable features in big files",
  pattern = "bigfile",
  callback = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match({ buf = args.buf }) or ""
    end)
  end,
})
