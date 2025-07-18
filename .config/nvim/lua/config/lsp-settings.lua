local util = require("config.util")
local set_keymap = util.keys.set
local methods = vim.lsp.protocol.Methods

vim.lsp.enable({
  "harper-ls",
  "bashls",
})

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    enabled = true,
    prefix = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return require("config.ui.icons").diagnostics.prefix .. require("config.ui.icons").diagnostics.error .. " "
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return require("config.ui.icons").diagnostics.prefix .. require("config.ui.icons").diagnostics.warn .. " "
      else
        return require("config.ui.icons").diagnostics.prefix .. require("config.ui.icons").diagnostics.info .. " "
      end
    end,
    suffix = require("config.ui.icons").diagnostics.suffix,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " " .. require("config.ui.icons").diagnostics.error,
      [vim.diagnostic.severity.WARN] = " " .. require("config.ui.icons").diagnostics.warn,
      [vim.diagnostic.severity.HINT] = " " .. require("config.ui.icons").diagnostics.hint,
      [vim.diagnostic.severity.INFO] = " " .. require("config.ui.icons").diagnostics.info,
    },
  },
})

-- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  set_keymap("n", "grd", function()
    require("fzf-lua").lsp_definitions({ jump1 = true })
  end, "Go to Definition", { buffer = bufnr }) --  To jump back, press <C-t>.
  set_keymap("n", "grD", function()
    require("fzf-lua").lsp_definitions({ jump1 = false })
  end, "Peek definition", { buffer = bufnr })
  set_keymap("n", "grr", "<cmd>FzfLua lsp_references<CR>", "Show References", { buffer = bufnr })
  set_keymap("n", "grs", "<cmd>FzfLua lsp_document_symbols<CR>", "Document Symbols", { buffer = bufnr })
  set_keymap("n", "grS", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Workspace Symbols", { buffer = bufnr })
  set_keymap({ "n", "v" }, "gra", function()
    require("tiny-code-action").code_action()
  end, "Code actions", { buffer = bufnr })
  set_keymap(
    "n",
    "<leader>D",
    "<cmd>FzfLua lsp_document_diagnostics bufnr=0<CR>",
    "Show buffer diagnostics",
    { buffer = bufnr }
  )
  set_keymap("n", "<leader>cd", vim.diagnostic.open_float, "Show line diagnostics", { buffer = bufnr })
  set_keymap("n", "]d", util.lsp.diagnostic_go_to("next"), "Next Diagnostic", { buffer = bufnr })
  set_keymap("n", "[d", util.lsp.diagnostic_go_to("prev"), "Prev Diagnostic", { buffer = bufnr })
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
  set_keymap("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", { buffer = bufnr })
  set_keymap("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP", { buffer = bufnr })

  -- Typescript specific keymaps.
  if client.name == "vtsls" then
    set_keymap(
      "n",
      "<leader>co",
      require("config.util").lsp.action["source.organizeImports"],
      "Organize Imports",
      { buffer = bufnr }
    )
    set_keymap(
      "n",
      "<leader>cM",
      require("config.util").lsp.action["source.addMissingImports.ts"],
      "Add missing imports",
      { buffer = bufnr }
    )
    set_keymap(
      "n",
      "<leader>cu",
      require("config.util").lsp.action["source.removeUnused.ts"],
      "Remove unused imports",
      { buffer = bufnr }
    )
    set_keymap(
      "n",
      "<leader>cD",
      require("config.util").lsp.action["source.fixAll.ts"],
      "Fix all diagnostics",
      { buffer = bufnr }
    )
    set_keymap("n", "<leader>cV", function()
      require("config.util").lsp.execute({ command = "typescript.selectTypeScriptVersion" })
    end, "Select TS workspace version", { buffer = bufnr })
  end

  vim.lsp.document_color.enable(true, bufnr)

  -- The following code creates a keymap to toggle inlay hints in your
  -- code, if the language server you are using supports them
  if client:supports_method(methods.textDocument_inlayHint) then
    set_keymap("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
    end, "Toggle Inlay Hints", { buffer = bufnr })
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
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
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
