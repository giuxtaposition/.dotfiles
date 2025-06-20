local util = require("config.util")
local set_keymap = util.keys.set
local methods = vim.lsp.protocol.Methods

vim.lsp.enable({
  "lua-ls",
  "harper-ls",
  "texlab",
  "nixd",
  "jsonls",
  "vtsls",
  "eslint",
  "bashls",
  "marksman",
  "gopls",
  "ruby-ls",
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
  set_keymap("n", "gd", function()
    require("fzf-lua").lsp_definitions({ jump1 = true })
  end, "Go to Definition", { buffer = bufnr }) --  To jump back, press <C-t>.
  set_keymap("n", "gD", function()
    require("fzf-lua").lsp_definitions({ jump1 = false })
  end, "Peek definition", { buffer = bufnr })
  set_keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", "Show References", { buffer = bufnr })
  set_keymap("n", "gI", vim.lsp.buf.implementation, "Go to Implementation", { buffer = bufnr })
  set_keymap("n", "gt", vim.lsp.buf.type_definition, "Type Definition", { buffer = bufnr })
  set_keymap("n", "<leader>cs", "<cmd>FzfLua lsp_document_symbols<CR>", "Document Symbols", { buffer = bufnr })
  set_keymap("n", "<leader>cS", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Workspace Symbols", { buffer = bufnr })
  set_keymap("n", "<leader>cr", function()
    local inc_rename = require("inc_rename")
    return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
  end, "Rename", { buffer = bufnr, expr = true })
  set_keymap({ "n", "v" }, "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", "Code actions", { buffer = bufnr })
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
  set_keymap("n", "]e", util.lsp.diagnostic_go_to("next", "ERROR"), "Next Error", { buffer = bufnr })
  set_keymap("n", "[e", util.lsp.diagnostic_go_to("prev", "ERROR"), "Prev Error", { buffer = bufnr })
  set_keymap("n", "]w", util.lsp.diagnostic_go_to("next", "WARN"), "Next Warning", { buffer = bufnr })
  set_keymap("n", "[w", util.lsp.diagnostic_go_to("prev", "WARN"), "Prev Warning", { buffer = bufnr })
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

local function restart_lsp(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients({ bufnr = bufnr })
  else
    ---@diagnostic disable-next-line: deprecated
    clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  end

  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end

  vim.defer_fn(function()
    vim.cmd("edit")
  end, 100)
end

vim.api.nvim_create_user_command("LspRestart", function()
  restart_lsp()
end, {})

local function lsp_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    print("󰅚 No LSP clients attached")
    return
  end

  print("󰒋 LSP Status for buffer " .. bufnr .. ":")
  print("─────────────────────────────────")

  for i, client in ipairs(clients) do
    print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
    print("  Root: " .. (client.config.root_dir or "N/A"))
    print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

    -- Check capabilities
    local caps = client.server_capabilities

    if caps == nil then
      print("  No capabilities reported")
      return
    end

    local features = {}
    if caps.completionProvider then
      table.insert(features, "completion")
    end
    if caps.hoverProvider then
      table.insert(features, "hover")
    end
    if caps.definitionProvider then
      table.insert(features, "definition")
    end
    if caps.referencesProvider then
      table.insert(features, "references")
    end
    if caps.renameProvider then
      table.insert(features, "rename")
    end
    if caps.codeActionProvider then
      table.insert(features, "code_action")
    end
    if caps.documentFormattingProvider then
      table.insert(features, "formatting")
    end

    print("  Features: " .. table.concat(features, ", "))
    print("")
  end
end

vim.api.nvim_create_user_command("LspStatus", lsp_status, { desc = "Show detailed LSP status" })
