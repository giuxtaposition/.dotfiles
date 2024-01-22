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

opt.inccommand = "split" -- Get a preview of replacements

opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.showmode = false -- Dont show mode since we have a statusline

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
opt.clipboard = "unnamedplus" -- Sync with system clipboard

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- split windows
opt.splitright = true
opt.splitbelow = true

-- spell check
opt.spelllang = { "en", "it" }

-- file undo
opt.undofile = true -- save undo history
opt.undolevels = 10000

opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- fold
opt.foldlevel = 99
opt.foldtext = "v:lua.require'giuxtaposition.config.util'.foldtext()"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'giuxtaposition.config.util'.foldexpr()"

opt.statuscolumn = [[%!v:lua.require'giuxtaposition.config.util'.statuscolumn()]]

opt.smoothscroll = true
