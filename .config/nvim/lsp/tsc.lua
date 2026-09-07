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

---@type vim.lsp.Config
return {
  cmd = { "tsc", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  init_options = {
    plugins = {
      { name = "@vue/typescript-plugin", languages = { "vue" } },
      { name = "@astrojs/ts-plugin", languages = { "astro" } },
      { name = "typescript-svelte-plugin", languages = { "svelte" } },
    },
  },
  root_markers = { { "tsconfig.json", "package.json", "jsconfig.json" }, ".git" },
  single_file_support = true,
  settings = {
    javascript = lang_settings,
    typescript = lang_settings,
  },
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.semanticTokensProvider = nil
    end

    local function code_action(action)
      return function()
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { action }, diagnostics = {} },
        })
      end
    end

    local opts = function(desc)
      return { buffer = bufnr, desc = desc, silent = true }
    end
    vim.keymap.set("n", "<leader>co", code_action("source.organizeImports"), opts("Organize Imports"))
    vim.keymap.set("n", "<leader>cu", code_action("source.removeUnusedImports"), opts("Remove unused imports"))
    vim.keymap.set("n", "<leader>cs", code_action("source.sortImports"), opts("Sort imports"))
    vim.keymap.set("n", "<leader>cD", code_action("source.fixAll"), opts("Fix all diagnostics"))
  end,
}
