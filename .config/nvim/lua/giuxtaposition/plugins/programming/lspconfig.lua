return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} }, -- lua development
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
		},
		"nvimdev/lspsaga.nvim", -- enhanced ui for lsp
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local lspsaga_diagnostic = require("lspsaga.diagnostic")
		local neodev = require("neodev")
		local typescript_tools = require("typescript-tools")

		vim.diagnostic.config({
			underline = true,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
			},
			severity_sort = true,
		})

		-- enable keybinds only for when lsp server available
		local on_attach = function(client, buffer)
			local Map = require("giuxtaposition.config.util").Map

			Map("n", "gf", "<cmd>Lspsaga finder<CR>", { desc = "References", buffer = buffer })
			Map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Goto Definition", buffer = buffer })
			Map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action", buffer = buffer })
			Map("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", { desc = "Rename", buffer = buffer })
			Map(
				"n",
				"<leader>cD",
				"<cmd>Lspsaga show_line_diagnostics<CR>",
				{ desc = "Line Diagnostics", buffer = buffer }
			)
			Map(
				"n",
				"<leader>cd",
				"<cmd>Lspsaga show_cursor_diagnostics<CR>",
				{ desc = "Cursor Diagnostics", buffer = buffer }
			)
			Map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Prev Diagnostic", buffer = buffer })
			Map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { desc = "Next Diagnostic", buffer = buffer })
			Map("n", "[e", function()
				lspsaga_diagnostic:goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Prev Error", buffer = buffer })
			Map("n", "]e", function()
				lspsaga_diagnostic:goto_next({ severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Next Error", buffer = buffer })
			Map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Documentation", buffer = buffer })

			-- Map("n", "<leader>ce", vim.diagnostic.open_float)
			-- Map("n", "[d", vim.diagnostic.goto_prev)
			-- Map("n", "]d", vim.diagnostic.goto_next)
			-- Map("n", "<leader>cq", vim.diagnostic.setloclist)
			--
			-- Map("n", "gD", vim.lsp.buf.declaration)
			-- Map("n", "gd", vim.lsp.buf.definition)
			-- Map("n", "K", vim.lsp.buf.hover)
			-- Map("n", "gi", vim.lsp.buf.implementation)
			-- Map("n", "<C-k>", vim.lsp.buf.signature_help)
			-- Map("n", "<space>D", vim.lsp.buf.type_definition)
			-- Map("n", "<space>rn", vim.lsp.buf.rename)
			-- Map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action)
			-- Map("n", "gr", vim.lsp.buf.references)
			-- Map("n", "<space>f", function()
			-- 	vim.lsp.buf.format({ async = true })
			-- end)

			if client.name == "typescript-tools" then
				Map(
					"n",
					"<leader>co",
					"<cmd>TSToolsOrganizeImports<cr>",
					{ desc = "Organize Imports", buffer = buffer }
				)
				Map("n", "<leader>cc", "<cmd>TSToolsRemoveUnused<cr>", { desc = "Remove Unused", buffer = buffer })
				Map("n", "<leader>cC", "<cmd>TSC<cr>", { desc = "Check Compile Errors", buffer = buffer })
				Map(
					"n",
					"<leader>cA",
					"<cmd>TSToolsAddMissingImports<cr>",
					{ desc = "Add Missing Imports", buffer = buffer }
				)
				Map("n", "<leader>cF", "<cmd>TSToolsRenameFile<cr>", { desc = "Rename File", buffer = buffer })
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
		typescript_tools.setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				if vim.lsp.inlay_hint then
					vim.lsp.inlay_hint.enable(bufnr, true)
				end

				on_attach(client, bufnr)
			end,
			settings = {
				separate_diagnostic_server = true,
				composite_mode = "separate_diagnostic",
				expose_as_code_action = {},
				complete_function_calls = true,
				tsserver_file_preferences = {
					includeCompletionsForModuleExports = true,
					quotePreference = "auto",
					importModuleSpecifierPreference = "relative",

					-- inlay hints
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		})

		lspconfig["svelte"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
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

		-- nix
		lspconfig["nil_ls"].setup({
			autostart = true,
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["nil"] = {
					formatting = {
						command = { "nixpkgs-fmt" },
					},
				},
			},
		})

		-- bash
		lspconfig["bashls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
