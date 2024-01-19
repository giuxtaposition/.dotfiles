require("config.nixosExtra")
local opt = vim.opt
local cmd = vim.cmd

opt.termguicolors = true

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- fold
opt.foldcolumn = "1" -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

opt.inccommand = "split" -- Get a preview of replacements

-- line wrapping
opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Undercurl
cmd([[let &t_Cs = "\e[4:3m"]])
cmd([[let &t_Ce = "\e[4:0m"]])

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- spell check
opt.spelllang = { "en_us", "it_it" }

-- file undo
opt.undofile = true -- save undo history
opt.undolevels = 10000
