-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- add list of plugins to install
local plugins = {
	-----------------------
	---- General
	-----------------------
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	{ "anuvyklack/windows.nvim", dependencies = { "anuvyklack/middleclass" } }, -- maximizes and restores current window
	-- faster editing plugins
	"tpope/vim-surround", -- surround word
	"vim-scripts/ReplaceWithRegister", -- replace words
	"numToStr/Comment.nvim", -- commenting lines with gc

	-- fuzzy finding w/ telescope
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x" }, -- fuzzy finder
	-- session manager
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "/" },
				session_lens = {
					buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
					load_on_setup = true,
					theme_conf = { border = true },
					previewer = true,
				},
			})
		end,
	},
	-- smart splits with wezterm support
	{ "mrjones2014/smart-splits.nvim", lazy = false },

	-----------------------
	---- UI
	-----------------------
	-- better ui for messages, cmdline and popupmenu
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 }, -- colorscheme
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	"nvim-tree/nvim-tree.lua", -- file explorer
	"nvim-tree/nvim-web-devicons", -- icons
	"nvim-lualine/lualine.nvim", -- statusline
	"akinsho/bufferline.nvim", -- enhanced tab ui
	"norcalli/nvim-colorizer.lua", -- color highlighter
	"lukas-reineke/indent-blankline.nvim", -- color indentation
	"HiPhish/rainbow-delimiters.nvim", -- color brackets
	-- enhanced ui for lsp
	{
		"glepnir/lspsaga.nvim",
		branch = "main",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- enhanced ui for diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-----------------------
	---- CODING
	-----------------------
	-- autocompletion
	"hrsh7th/nvim-cmp", -- autocompletion plugin
	"hrsh7th/cmp-buffer", -- source for recommending text in current buffer
	"hrsh7th/cmp-path", -- source for recommending file system paths
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	-- snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"saadparwaiz1/cmp_luasnip", -- recommend snippets for autocompletion with nvim-cmp
	"rafamadriz/friendly-snippets", -- ful snippets

	-- managing & installing lsp servers, linters & formatters
	"williamboman/mason.nvim", -- manages lsp servers, linters and formatters
	"williamboman/mason-lspconfig.nvim", -- integration between mason and lsp config

	-- configuring lsp servers
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp", --  lsp servers as source for autocompletion

	-- faster alternative for typescript language server
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	},

	-- formatting & linting
	"jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
	"jayp0521/mason-null-ls.nvim", -- integration between mason and null-ls

	-- highlight code
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	},

	-- auto closing
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...
	"windwp/nvim-ts-autotag", -- autoclose tags

	-- git integration
	"lewis6991/gitsigns.nvim", -- show line modifications on left hand side
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
		},
		config = true,
	},

	-- testing
	{
		"nvim-neotest/neotest",
		dependencies = {
			"haydenmeade/neotest-jest",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-plenary",
		},
	},

	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		config = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
