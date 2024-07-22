return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.diagnostic.config({
      underline = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
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

    -- enable keybinds only for when lsp server available
    local on_attach = function(client, buffer)
      local Map = require("config.util").map
      local diagnostic_goto = function(count, severity)
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
          vim.diagnostic.jump({ count = count, severity = severity })
        end
      end

      Map("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "References", buffer = buffer })
      Map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      Map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition", buffer = buffer })
      Map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Show LSP implementations", buffer = buffer })
      Map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Show LSP type definitions", buffer = buffer })
      Map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions", buffer = buffer })
      Map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Smart rename", buffer = buffer })
      Map(
        "n",
        "<leader>D",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        { desc = "Show buffer diagnostics", buffer = buffer }
      )
      Map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show line diagnostics", buffer = buffer }) -- show diagnostics for line
      Map("n", "]d", diagnostic_goto(1), { desc = "Next Diagnostic", buffer = buffer })
      Map("n", "[d", diagnostic_goto(-1), { desc = "Prev Diagnostic", buffer = buffer })
      Map("n", "]e", diagnostic_goto(1, "ERROR"), { desc = "Next Error", buffer = buffer })
      Map("n", "[e", diagnostic_goto(-1, "ERROR"), { desc = "Prev Error", buffer = buffer })
      Map("n", "]w", diagnostic_goto(1, "WARN"), { desc = "Next Warning" })
      Map("n", "[w", diagnostic_goto(-1, "WARN"), { desc = "Prev Warning", buffer = buffer })
      Map("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor", buffer = buffer })
      Map("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", buffer = buffer })

      if client.name == "vtsls" then
        local execute = require("config.util").execute
        Map("n", "gD", function()
          local params = vim.lsp.util.make_position_params()
          execute({
            command = "typescript.goToSourceDefinition",
            arguments = { params.textDocument.uri, params.position },
            open = true,
          })
        end, { desc = "Goto Source Definition" })

        Map("n", "gR", function()
          execute({
            command = "typescript.findAllFileReferences",
            arguments = { vim.uri_from_bufnr(0) },
            open = true,
          })
        end, { desc = "File References" })

        Map("n", "<leader>co", require("config.util").action["source.organizeImports"], { desc = "Organize Imports" })

        Map(
          "n",
          "<leader>cM",
          require("config.util").action["source.addMissingImports.ts"],
          { desc = "Add missing imports" }
        )

        Map(
          "n",
          "<leader>cu",
          require("config.util").action["source.removeUnused.ts"],
          { desc = "Remove unused imports" }
        )

        Map("n", "<leader>cD", require("config.util").action["source.fixAll.ts"], { desc = "Fix all diagnostics" })

        Map("n", "<leader>cV", function()
          execute({ command = "typescript.selectTypeScriptVersion" })
        end, { desc = "Select TS workspace version" })
      end
    end

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    })

    lspconfig.vtsls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        complete_function_calls = true,
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
        javascript = {
          preferences = {
            importModuleSpecifier = "relative",
          },
        },
        typescript = {
          preferences = {
            importModuleSpecifier = "relative",
          },
          tsserver = {
            experimental = {
              enableProjectDiagnostics = false, -- when true it always open all json in the project?
            },
          },
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    })

    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      settings = {
        workingDirectories = { mode = "auto" },
      },
    })

    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["volar"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
      root_dir = util.root_pattern("src/App.vue"),
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

    -- clangd
    lspconfig["clangd"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        require("clangd_extension").setup()

        on_attach(client, bufnr)
      end,
    })

    -- kotlin
    lspconfig.kotlin_language_server.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- gopls
    lspconfig.gopls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    })
  end,
}
