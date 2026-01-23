local util = require("config.util")
local icons = require("config.ui.icons")
local set_keymap = util.keys.set
local methods = vim.lsp.protocol.Methods

vim.lsp.enable({
  "harper-ls",
  "copilot",
  "lua-ls",
  "bashls",
  "jsonls",
  "texlab",
  "marksman",
  "nixd",
  "phpactor",
  "intelephense",
  "vtsls",
  "eslint",
  "cssls",
  "vue-ls",
  "html",
})

vim.diagnostic.config({
  underline = true,
  status = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
    },
  },
  virtual_text = {
    enabled = true,
    spacing = 2,
    prefix = icons.diagnostics.prefix,
    suffix = icons.diagnostics.suffix,
    format = function(diagnostic)
      local special_sources = {
        ["Lua Diagnostics."] = "lua",
        ["Lua Syntax Check."] = "lua",
      }

      local message = icons.diagnostics[string.lower(vim.diagnostic.severity[diagnostic.severity])]
      if diagnostic.source then
        message = string.format("%s [%s]", message, special_sources[diagnostic.source] or diagnostic.source)
      end

      return message .. " " .. diagnostic.message .. " "
    end,
  },
  severity_sort = true,
  float = {
    source = "if_many",
    -- Show severity icons as prefixes.
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(" %s ", icons.diagnostics[level])
      return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
    end,
  },
  -- Disable signs in the gutter.
  signs = false,
})

-- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  set_keymap("n", "grS", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Workspace Symbols", { buffer = bufnr })
  set_keymap(
    "n",
    "<leader>D",
    "<cmd>FzfLua lsp_document_diagnostics bufnr=0<CR>",
    "Show buffer diagnostics",
    { buffer = bufnr }
  )
  set_keymap("n", "<leader>cd", vim.diagnostic.open_float, "Show line diagnostics", { buffer = bufnr })
  set_keymap(
    "n",
    "]e",
    util.lsp.diagnostic_go_to("next", vim.diagnostic.severity.ERROR),
    "Next Error",
    { buffer = bufnr }
  )
  set_keymap(
    "n",
    "[e",
    util.lsp.diagnostic_go_to("prev", vim.diagnostic.severity.ERROR),
    "Prev Error",
    { buffer = bufnr }
  )
  set_keymap(
    "n",
    "]w",
    util.lsp.diagnostic_go_to("next", vim.diagnostic.severity.WARN),
    "Next Warning",
    { buffer = bufnr }
  )
  set_keymap(
    "n",
    "[w",
    util.lsp.diagnostic_go_to("prev", vim.diagnostic.severity.WARN),
    "Prev Warning",
    { buffer = bufnr }
  )
  set_keymap("n", "]r", util.lsp.jump_to_reference("next"), "Next Warning", { buffer = bufnr })
  set_keymap("n", "[r", util.lsp.jump_to_reference("prev"), "Prev Warning", { buffer = bufnr })

  -- Enable LLM-based inline completion
  if client:supports_method(methods.textDocument_inlineCompletion) then
    vim.lsp.inline_completion.enable()
    set_keymap("i", "<C-.>", function()
      if not vim.lsp.inline_completion.get() then
        return "<C-.>"
      end
    end, "Apply the currently displayed completion suggestion", { expr = true, replace_keycodes = true })
    set_keymap("i", "<M-n>", function()
      vim.lsp.inline_completion.select({})
    end, "Show next inline completion suggestion")
    set_keymap("i", "<M-p>", function()
      vim.lsp.inline_completion.select({ count = -1 })
    end, "Show previous inline completion suggestion")
  end

  vim.lsp.document_color.enable(true, bufnr)
  if client:supports_method(methods.textDocument_documentColor) then
    set_keymap({ "n", "x" }, "grc", function()
      vim.lsp.document_color.color_presentation()
    end, "vim.lsp.document_color.color_presentation()")
  end

  if client:supports_method(methods.textDocument_codeAction) then
    set_keymap({ "n", "v" }, "gra", function()
      require("tiny-code-action").code_action()
    end, "Code actions", { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    set_keymap("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
    end, "Toggle Inlay Hints", { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_references) then
    set_keymap("n", "grr", "<cmd>FzfLua lsp_references<CR>", "Show References", { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_typeDefinition) then
    set_keymap("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", "Go to type definition", { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_documentSymbol) then
    set_keymap("n", "gO", "<cmd>FzfLua lsp_document_symbols<CR>", "Document Symbols", { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_definition) then
    set_keymap("n", "grd", function()
      require("fzf-lua").lsp_definitions({ jump1 = true })
    end, "Go to Definition", { buffer = bufnr }) --  To jump back, press <C-t>.
    set_keymap("n", "grD", function()
      require("fzf-lua").lsp_definitions({ jump1 = false })
    end, "Peek definition", { buffer = bufnr })
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    set_keymap({ "n", "i" }, "<C-k>", function()
      -- Close the completion menu first (if open).
      if require("blink.cmp.completion.windows.menu").win:is_open() then
        require("blink.cmp").hide()
      end

      vim.lsp.buf.signature_help()
    end, "Signature help")
  end

  if client:supports_method(methods.textDocument_foldingRange) then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
  else
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup("giuxtaposition-lsp-highlight", { clear = false })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      desc = "Highlight references under the cursor",
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      desc = "Clear all the references highlights",
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("giuxtaposition-lsp-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "giuxtaposition-lsp-highlight", buffer = event2.buf })
      end,
    })
  else
    require("config.ui.highlight_matching_words_under_cursor").setup()
  end

  util.lsp.run_hooks(client, bufnr)
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("giuxtaposition-lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then
      return
    end

    on_attach(client, event.buf)
  end,
})

-- Extras

vim.api.nvim_create_user_command("LspRestart", function()
  util.lsp.restart_lsp()
end, {})

vim.api.nvim_create_user_command("LspStatus", util.lsp.lsp_status, { desc = "Show detailed LSP status" })
