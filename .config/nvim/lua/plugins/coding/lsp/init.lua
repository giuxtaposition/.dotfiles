local util = require("config.util")
local set_keymap = util.keys.set
local methods = vim.lsp.protocol.Methods

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = require("config.ui.icons").diagnostics.prefix,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("config.ui.icons").diagnostics.error,
      [vim.diagnostic.severity.WARN] = require("config.ui.icons").diagnostics.warn,
      [vim.diagnostic.severity.HINT] = require("config.ui.icons").diagnostics.hint,
      [vim.diagnostic.severity.INFO] = require("config.ui.icons").diagnostics.info,
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("giuxtaposition-lsp-attach", { clear = true }),
  callback = function(event)
    set_keymap("n", "gd", function()
      require("fzf-lua").lsp_definitions({ jump1 = true })
    end, "Go to Definition", { buffer = event.buf }) --  To jump back, press <C-t>.
    set_keymap("n", "gD", function()
      require("fzf-lua").lsp_definitions({ jump1 = false })
    end, "Peek definition", { buffer = event.buf })
    set_keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", "Show References", { buffer = event.buf })
    set_keymap("n", "gI", vim.lsp.buf.implementation, "Go to Implementation", { buffer = event.buf })
    set_keymap("n", "gt", vim.lsp.buf.type_definition, "Type Definition", { buffer = event.buf })
    set_keymap("n", "<leader>cs", "<cmd>FzfLua lsp_document_symbols<CR>", "Document Symbols", { buffer = event.buf })
    set_keymap("n", "<leader>cS", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Workspace Symbols", { buffer = event.buf })
    set_keymap("n", "<leader>cr", function()
      local inc_rename = require("inc_rename")
      return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
    end, "Rename", { buffer = event.buf, expr = true })
    set_keymap({ "n", "v" }, "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", "Code actions", { buffer = event.buf })
    set_keymap(
      "n",
      "<leader>D",
      "<cmd>FzfLua lsp_document_diagnostics bufnr=0<CR>",
      "Show buffer diagnostics",
      { buffer = event.buf }
    )
    set_keymap("n", "<leader>cd", vim.diagnostic.open_float, "Show line diagnostics", { buffer = event.buf })
    set_keymap("n", "]d", util.lsp.diagnostic_go_to("next"), "Next Diagnostic", { buffer = event.buf })
    set_keymap("n", "[d", util.lsp.diagnostic_go_to("prev"), "Prev Diagnostic", { buffer = event.buf })
    set_keymap("n", "]e", util.lsp.diagnostic_go_to("next", "ERROR"), "Next Error", { buffer = event.buf })
    set_keymap("n", "[e", util.lsp.diagnostic_go_to("prev", "ERROR"), "Prev Error", { buffer = event.buf })
    set_keymap("n", "]w", util.lsp.diagnostic_go_to("next", "WARN"), "Next Warning", { buffer = event.buf })
    set_keymap("n", "[w", util.lsp.diagnostic_go_to("prev", "WARN"), "Prev Warning", { buffer = event.buf })
    set_keymap("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", { buffer = event.buf }) --TODO
    set_keymap("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP", { buffer = event.buf })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    vim.lsp.document_color.enable(true, event.buf)

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    if client:supports_method(methods.textDocument_inlayHint) then
      set_keymap("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "Toggle Inlay Hints", { buffer = event.buf })
    end

    if client:supports_method(methods.textDocument_foldingRange) then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    if client:supports_method(methods.textDocument_documentHighlight) then
      local under_cursor_highlights_group =
        vim.api.nvim_create_augroup("giuxtaposition/cursor_highlights", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        group = under_cursor_highlights_group,
        desc = "Highlight references under the cursor",
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        group = under_cursor_highlights_group,
        desc = "Clear highlight references",
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      require("lspconfig.ui.windows").default_options.border = "rounded"

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, opts.servers[server] or {})

        if server_opts.enabled == false then
          return
        end

        if server_opts.keys then
          server_opts.on_attach = function(_, bufnr)
            for _, value in pairs(server_opts.keys) do
              set_keymap("n", value[1], value[2], value[3], { buffer = bufnr })
            end
          end
        end

        lspconfig[server].setup(server_opts)
      end

      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        setup(server)
      end
    end,
  },
  --- LSP-like explanation for patterns (regex, etc)
  {
    "OXY2DEV/patterns.nvim",
    keys = {
      {
        "H",
        "<cmd>Patterns hover<cr>",
        desc = "Show documentation for pattern under cursor",
      },
    },
  },
}
