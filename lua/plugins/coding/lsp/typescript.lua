local lang_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    variableTypes = { enabled = true },
  },
  preferences = {
    importModuleSpecifier = "relative",
  },
  updateImportsOnFileMove = { enabled = "always" },
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP wrapper for vtsls.
      "yioneko/nvim-vtsls",
    },
    opts = {
      servers = {
        vtsls = {
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                require("config.util").lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              "Goto Source Definition",
            },
            {
              "gR",
              function()
                require("config.util").lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              "File References",
            },
            {
              "<leader>co",
              require("config.util").lsp.action["source.organizeImports"],
              "Organize Imports",
            },
            {
              "<leader>cM",
              require("config.util").lsp.action["source.addMissingImports.ts"],
              "Add missing imports",
            },
            {
              "<leader>cu",
              require("config.util").lsp.action["source.removeUnused.ts"],
              "Remove unused imports",
            },
            {
              "<leader>cD",
              require("config.util").lsp.action["source.fixAll.ts"],
              "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                require("config.util").lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              "Select TS workspace version",
            },
          },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
          },
          settings = {
            javascript = lang_settings,
            typescript = lang_settings,
            vtsls = {
              complete_function_calls = true,
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
                maxInlayHintLength = 30,
              },
            },
          },
        },

        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },

        volar = {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
        },

        svelte = {},
        html = {},
        cssls = {},
        emmet_ls = {},
      },
    },
  },
  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "dmmulroy/tsc.nvim",
    opts = {
      use_trouble_qflist = true,
      auto_close_qflist = true,
    },
    config = function(_, opts)
      require("tsc").setup(opts)
    end,
  },
}
