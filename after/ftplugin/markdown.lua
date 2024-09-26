-- line wrapping
vim.opt.wrap = true

-- Visual Mode shorcuts
-- strike through, bold, and italic shortcuts
vim.keymap.set("v", "<localleader>s", 'c~~<c-r>"~~<esc>')
vim.keymap.set("v", "<localleader>b", 'c**<c-r>"**<esc>')
vim.keymap.set("v", "<localleader>i", 'c_<c-r>"_<esc>')

-- urls and titles
vim.keymap.set("v", "<localleader>t", 'c[<c-r>"]()<left>')
vim.keymap.set("v", "<localleader>u", 'c[](<c-r>")<c-o>F]')

-- wrap in backticks
vim.keymap.set("v", "<localleader>`", 'c`<c-r>"`<esc>')

-- Normal Mode shorcuts
-- strike through, bold, and italic shortcuts
vim.keymap.set("n", "<localleader>s", 'viwc~~<c-r>"~~<esc><esc>')
vim.keymap.set("n", "<localleader>b", 'viwc**<c-r>"**<esc><esc>')
vim.keymap.set("n", "<localleader>i", 'viwc_<c-r>"_<esc><esc>')

-- urls and titles
vim.keymap.set("n", "<localleader>t", 'viwc[<c-r>"]()<left>')
vim.keymap.set("n", "<localleader>u", 'viwc[](<c-r>")<c-o>F]')

-- wrap in backticks
vim.keymap.set("n", "<localleader>`", 'viwc`<c-r>"`<esc><esc>')
