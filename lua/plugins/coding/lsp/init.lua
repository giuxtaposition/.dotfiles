---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
---@param buffer boolean|integer O or true for current buffer
---@param additional_opts? vim.keymap.set.Opts
local map = function(mode, lhs, rhs, desc, buffer, additional_opts)
  local opts = vim.tbl_extend("force", { buffer = buffer, desc = desc, silent = true }, additional_opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      require("lspconfig.ui.windows").default_options.border = "rounded"

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("giuxtaposition-lsp-attach", { clear = true }),
        callback = function(event)
          local diagnostic_goto = function(count, severity)
            severity = severity and vim.diagnostic.severity[severity] or nil
            return function()
              vim.diagnostic.jump({
                count = count,
                severity = severity,
                float = { border = "rounded", max_width = 100 },
              })
            end
          end

          map("n", "gd", vim.lsp.buf.definition, "Goto Definition", event.buf) --  To jump back, press <C-t>.
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", event.buf)
          map("n", "gr", "<cmd>FzfLua lsp_references<CR>", "Show References", event.buf)
          map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation", event.buf)
          map("n", "gt", vim.lsp.buf.type_definition, "Type Definition", event.buf)
          map("n", "<leader>cs", "<cmd>FzfLua lsp_document_symbols<CR>", "Document Symbols", event.buf)
          map("n", "<leader>cS", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Workspace Symbols", event.buf)
          map("n", "<leader>cr", function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
          end, "Rename", event.buf, { expr = true })
          map("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", "Code Action", event.buf)
          map("v", "<leader>ca", "<cmd>'<,'>FzfLua lsp_code_actions<CR>", "Code Action", event.buf)
          map(
            "n",
            "<leader>D",
            "<cmd>FzfLua lsp_document_diagnostics bufnr=0<CR>",
            "Show buffer diagnostics",
            event.buf
          )
          map("n", "<leader>cd", vim.diagnostic.open_float, "Show line diagnostics", event.buf)
          map("n", "]d", diagnostic_goto(1), "Next Diagnostic", event.buf)
          map("n", "[d", diagnostic_goto(-1), "Prev Diagnostic", event.buf)
          map("n", "]e", diagnostic_goto(1, "ERROR"), "Next Error", event.buf)
          map("n", "[e", diagnostic_goto(-1, "ERROR"), "Prev Error", event.buf)
          map("n", "]w", diagnostic_goto(1, "WARN"), "Next Warning", event.buf)
          map("n", "[w", diagnostic_goto(-1, "WARN"), "Prev Warning", event.buf)
          map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", event.buf) --TODO
          map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP", event.buf)

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints", event.buf)
          end
        end,
      })

      vim.diagnostic.config({
        underline = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = require("config.icons").diagnostics.prefix,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("config.icons").diagnostics.error,
            [vim.diagnostic.severity.WARN] = require("config.icons").diagnostics.warn,
            [vim.diagnostic.severity.HINT] = require("config.icons").diagnostics.hint,
            [vim.diagnostic.severity.INFO] = require("config.icons").diagnostics.info,
          },
        },
      })

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
              map("n", value[1], value[2], value[3], bufnr)
            end
          end
        end

        lspconfig[server].setup(server_opts)
      end

      for server in pairs(opts.servers) do
        setup(server)
      end
    end,
  },
}
