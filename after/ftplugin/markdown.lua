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
