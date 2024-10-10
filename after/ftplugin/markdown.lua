-- line wrapping
vim.opt.wrap = true

-- Visual Mode shortcuts
vim.keymap.set("v", "<localleader>s", 'c~~<c-r>"~~<esc>', {
  desc = "Strikethrough",
})
vim.keymap.set("v", "<localleader>b", 'c**<c-r>"**<esc>', {
  desc = "Bold",
})
vim.keymap.set("v", "<localleader>i", 'c_<c-r>"_<esc>', {
  desc = "Italic",
})
vim.keymap.set("v", "<localleader>t", 'c[<c-r>"]()<left>', {
  desc = "Url with text as label",
})
vim.keymap.set("v", "<localleader>u", 'c[](<c-r>")<c-o>F]', {
  desc = "Url with text as link",
})
vim.keymap.set("v", "<localleader>`", 'c`<c-r>"`<esc>', {
  desc = "Wrap in backticks",
})
vim.keymap.set("v", "<localleader>c", 'c-<Space>[<Space>]<Space><c-r>"<esc><esc>', {
  desc = "Add checkbox",
})

-- Normal Mode shortcuts
vim.keymap.set("n", "<localleader>s", 'viwc~~<c-r>"~~<esc><esc>', {
  desc = "Strikethrough",
})
vim.keymap.set("n", "<localleader>b", 'viwc**<c-r>"**<esc><esc>', {
  desc = "Bold",
})
vim.keymap.set("n", "<localleader>i", 'viwc_<c-r>"_<esc><esc>', {
  desc = "Italic",
})
vim.keymap.set("n", "<localleader>t", 'viwc[<c-r>"]()<left>', {
  desc = "Url with text as label",
})
vim.keymap.set("n", "<localleader>u", 'viwc[](<c-r>")<c-o>F]', {
  desc = "Url with text as link",
})
vim.keymap.set("n", "<localleader>`", 'viwc`<c-r>"`<esc><esc>', {
  desc = "Wrap in backticks",
})
vim.keymap.set("n", "<localleader>c", 'viwc-<Space>[<Space>]<Space><c-r>"<esc><esc>', {
  desc = "Add checkbox",
})

-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  local function map(...)
    vim.api.nvim_buf_set_keymap(0, ...)
  end
  local opts = { noremap = true, silent = false }

  opts.desc = "Open the link under cursor"
  map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

  opts.desc = "Create a new note"
  map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)

  opts.desc = "Create a new note with the current selection as title"
  map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", opts)

  opts.desc = "Create a new note with the current selection as content"
  map(
    "v",
    "<leader>znc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    opts
  )

  opts.desc = "Open notes linking to the current buffer"
  map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)

  opts.desc = "Open notes linked by the current buffer"
  map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)

  opts.desc = "Preview a linked note"
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)

  opts.desc = "Open the code actions for a visual selection"
  map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end
