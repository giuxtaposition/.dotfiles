---@type vim.lsp.Config
return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
  },
  settings = {
    eslint = {
      validate = "on",
      packageManager = vim.NIL,
      useESLintClass = false,
      codeActionOnSave = { enable = false, mode = "all" },
      format = false,
      quiet = false,
      onIgnoredFiles = "off",
      options = {},
      rulesCustomizations = {},
      run = "onType",
      problems = { shortenToSingleLine = false },
      nodePath = "",
      workingDirectory = { mode = "location" },
      codeAction = {
        disableRuleComment = { enable = true, location = "separateLine" },
        showDocumentation = { enable = true },
      },
    },
  },
  before_init = function(params, config)
    local root = params.workspaceFolders and params.workspaceFolders[1]
      or { uri = vim.uri_from_fname(params.rootPath or vim.fn.getcwd()), name = "workspace" }
    config.settings.eslint.workspaceFolder = {
      uri = root.uri,
      name = root.name or vim.fn.fnamemodify(vim.uri_to_fname(root.uri), ":t"),
    }
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
