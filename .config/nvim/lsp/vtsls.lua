local lang_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    variableTypes = { enabled = true },
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
  },
  preferences = {
    importModuleSpecifier = "relative",
  },
  updateImportsOnFileMove = { enabled = "always" },
}

local vue_plugin = {
  name = "@vue/typescript-plugin",
  languages = { "vue" },
  configNamespace = "typescript",
}

---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  root_markers = { { "tsconfig.json", "package.json", "jsconfig.json" }, ".git" },
  single_file_support = true,
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
      tsserver = {
        globalPlugins = {
          {
            name = "typescript-svelte-plugin",
            enableForWorkspaceTypeScriptVersions = true,
          },
          vue_plugin,
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
}
