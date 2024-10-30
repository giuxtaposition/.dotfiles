local set_keymap = require("config.util.init").keys.set
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

          set_keymap("n", "gd", function()
            require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
          end, "Go to Definition", { buffer = event.buf }) --  To jump back, press <C-t>.
          set_keymap("n", "gD", "<cmd>FzfLua lsp_definitions<cr>", "Peek definition", { buffer = event.buf })
          set_keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", "Show References", { buffer = event.buf })
          set_keymap("n", "gI", vim.lsp.buf.implementation, "Go to Implementation", { buffer = event.buf })
          set_keymap("n", "gt", vim.lsp.buf.type_definition, "Type Definition", { buffer = event.buf })
          set_keymap(
            "n",
            "<leader>cs",
            "<cmd>FzfLua lsp_document_symbols<CR>",
            "Document Symbols",
            { buffer = event.buf }
          )
          set_keymap(
            "n",
            "<leader>cS",
            "<cmd>FzfLua lsp_workspace_symbols<CR>",
            "Workspace Symbols",
            { buffer = event.buf }
          )
          set_keymap("n", "<leader>cr", function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
          end, "Rename", { buffer = event.buf, expr = true })
          set_keymap(
            { "n", "v" },
            "<leader>ca",
            "<cmd>FzfLua lsp_code_actions<CR>",
            "Code actions",
            { buffer = event.buf }
          )
          set_keymap(
            "n",
            "<leader>D",
            "<cmd>FzfLua lsp_document_diagnostics bufnr=0<CR>",
            "Show buffer diagnostics",
            { buffer = event.buf }
          )
          set_keymap("n", "<leader>cd", vim.diagnostic.open_float, "Show line diagnostics", { buffer = event.buf })
          set_keymap("n", "]d", diagnostic_goto(1), "Next Diagnostic", { buffer = event.buf })
          set_keymap("n", "[d", diagnostic_goto(-1), "Prev Diagnostic", { buffer = event.buf })
          set_keymap("n", "]e", diagnostic_goto(1, "ERROR"), "Next Error", { buffer = event.buf })
          set_keymap("n", "[e", diagnostic_goto(-1, "ERROR"), "Prev Error", { buffer = event.buf })
          set_keymap("n", "]w", diagnostic_goto(1, "WARN"), "Next Warning", { buffer = event.buf })
          set_keymap("n", "[w", diagnostic_goto(-1, "WARN"), "Prev Warning", { buffer = event.buf })
          set_keymap("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", { buffer = event.buf }) --TODO
          set_keymap("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP", { buffer = event.buf })

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            set_keymap("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints", { buffer = event.buf })
          end
        end,
      })

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

      for server in pairs(opts.servers) do
        setup(server)
      end
    end,
  },
}
