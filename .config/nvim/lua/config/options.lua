-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
vim.g.have_nerd_font = true

local opt = vim.o

-- Line numbers
opt.relativenumber = true
opt.number = true -- Show absolute line number on cursor line

-- Tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- Expand tab to spaces
opt.autoindent = true -- Copy indent from current line when starting new one
opt.smartindent = true -- Smart indenting on new lines

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- If you include mixed case in your search, assume you want case-sensitive
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search matches while typing
opt.infercase = true -- Infer case in built-in completion
vim.opt.path:append("**") -- Search in sub-directories
vim.opt.wildignore:append({ "*/node_modules/*" }) -- Ignore node_modules when searching

-- Cursor line
opt.cursorline = true -- Highlight the current cursor line

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes" -- Show sign column so that text doesn't shift
opt.colorcolumn = "+2" -- Draw column on the right of maximum width

-- Backspace
opt.backspace = "indent,eol,start" -- Allow backspace on indent, end of line or insert mode start

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard as default register

-- Split windows
opt.splitright = true -- Split vertical window to the right
opt.splitbelow = true -- Split horizontal window to the bottom

-- Turn off swapfile
opt.swapfile = false

-- Sets how neovim will display certain whitespace characters in the editor.
opt.list = true
opt.listchars = "extends:…,nbsp:␣,precedes:…,tab:  ,trail:·"

-- Preview substitutions live, as you type!
opt.inccommand = "split"

opt.mouse = "" -- Disable mouse

opt.formatoptions = "rqnl1j" -- Improve comment editing

opt.scrolloff = 10 -- Minimum lines to keep above and below cursor

-- Spell checking
opt.spell = true
opt.spelllang = "en_us,it"
opt.spelloptions = "camel" -- Treat camelCase word parts as separate words
opt.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Folding
opt.foldcolumn = "1"
opt.foldlevelstart = 99
opt.foldtext = ""
opt.foldmethod = "indent" -- This is the default, but I set it to LSP if available.

-- UI characters.
vim.opt.fillchars = {
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  foldinner = " ",
  diff = "╱",
  eob = " ",
}

opt.smoothscroll = true

opt.undofile = true -- Save undo history
