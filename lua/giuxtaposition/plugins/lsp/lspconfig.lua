return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} }, -- lua development
		"jose-elias-alvarez/typescript.nvim", -- typescript development
		"nvimdev/lspsaga.nvim", -- enhanced ui for lsp
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local typescript = require("typescript")
		local lspsaga_diagnostic = require("lspsaga.diagnostic")
		local neodev = require("neodev")

		local keymap = vim.keymap

		-- enable keybinds only for when lsp server available
		local on_attach = function(client, bufnr)
			-- keybind options
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- set keybinds
			keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references
			keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
			keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
			keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
			keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
			keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
			keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts) -- jump to previous diagnostic in buffer
			keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts) -- jump to next diagnostic in buffer
			keymap.set("n", "[e", function()
				lspsaga_diagnostic:goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end, opts) -- jump to previous error in buffer
			keymap.set("n", "]e", function()
				lspsaga_diagnostic:goto_next({ severity = vim.diagnostic.severity.ERROR })
			end, opts) -- jump to next error in buffer
			keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
			keymap.set("i", "gs", function()
				vim.lsp.buf.signature_help()
			end, opts)

			if client.name == "tsserver" then
				keymap.set("n", "<leader>lo", ":TypescriptOrganizeImports<cr>", opts)
				keymap.set("n", "<leader>lu", ":TypescriptRemoveUnused<cr>", opts)
				keymap.set("n", "<leader>lz", ":TypescriptGoToSourceDefinition<cr>", opts)
				keymap.set("n", "<leader>lR", ":TypescriptRemoveUnused<cr>", opts)
				keymap.set("n", "<leader>lF", ":TypescriptRenameFile<cr>", opts)
				keymap.set("n", "<leader>lA", ":TypescriptAddMissingImports<cr>", opts)
			end
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure typescript server
		typescript.setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "relative",
						importModuleSpecifierEnding = "minimal",
					},
				},
			},
		})

		-- neodev
		neodev.setup({
			library = { plugins = { "neotest" }, types = true },
		})

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- markdown
		lspconfig["marksman"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
