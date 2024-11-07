-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
vim.g.have_nerd_font = true

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true -- show absolute line number on cursor line

-- tabs & identation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assume you want case-sensitive
opt.hlsearch = true -- highlight search results
opt.path:append("**") -- search in subdirectories
opt.wildignore:append({ "*/node_modules/*" }) -- ignore node_modules when searching

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- sets how neovim will display certain whitespace characters in the editor.
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- preview substitutions live, as you type!
opt.inccommand = "split"

opt.mouse = "" -- disable mouse

-- Add asterisks in block comments
opt.formatoptions:append({ "r" })

opt.scrolloff = 10 -- minimum lines to keep above and below cursor

-- Spell checking
opt.spell = true
opt.spelllang = "en_us,it"
