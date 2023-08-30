local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local status, typescript_tools = pcall(require, "typescript-tools")
if not status then
	return
end

local lspsaga_status, lspsaga_diagnostics = pcall(require, "lspsaga.diagnostic")
if not lspsaga_status then
	return
end

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
	keymap.set("n", "[d", "<cmd>lspsaga diagnostic_jump_prev<cr>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>lspsaga diagnostic_jump_next<cr>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "[e", function()
		lspsaga_diagnostics:goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, opts) -- jump to previous error in buffer
	keymap.set("n", "]e", function()
		lspsaga_diagnostics:goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, opts) -- jump to next error in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("i", "gs", function()
		vim.lsp.buf.signature_help()
	end, opts)

	if client.name == "tsserver" then
		keymap.set("n", "<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", opts)
		keymap.set("n", "<leader>lO", "<cmd>TSToolsSortImports<cr>", opts)
		keymap.set("n", "<leader>lu", "<cmd>TSToolsRemoveUnused<cr>", opts)
		keymap.set("n", "<leader>lz", "<cmd>TSToolsGoToSourceDefinition<cr>", opts)
		keymap.set("n", "<leader>lR", "<cmd>TSToolsRemoveUnusedImports<cr>", opts)
		keymap.set("n", "<leader>lF", "<cmd>TSToolsFixAll<cr>", opts)
		keymap.set("n", "<leader>lA", "<cmd>TSToolsAddMissingImports<cr>", opts)
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure typescript server
typescript_tools.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		expose_as_code_action = {
			"fix_all",
			"add_missing_imports",
			"remove_unused",
		},
		complete_function_calls = true,
		tsserver_file_preferences = {
			includeInlayParameterNameHints = "all",
			includeCompletionsForModuleExports = true,
			quotePreference = "auto",
			importModuleSpecifierPreference = "relative",
		},
	},
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

lspconfig["marksman"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
