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

    -- TypeScript-specific keymaps
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
    vim.keymap.set("n", "<leader>cM", code_action("source.addMissingImports.ts"), opts("Add missing imports"))
    vim.keymap.set("n", "<leader>cu", code_action("source.removeUnused.ts"), opts("Remove unused imports"))
    vim.keymap.set("n", "<leader>cD", code_action("source.fixAll.ts"), opts("Fix all diagnostics"))
    vim.keymap.set("n", "<leader>cV", function()
      vim.lsp.buf.execute_command({ command = "typescript.selectTypeScriptVersion" })
    end, opts("Select TS workspace version"))

    client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
      ---@type string, string, lsp.Range
      local action, uri, range = unpack(command.arguments)

      local function move(newf)
        client:request("workspace/executeCommand", {
          command = command.command,
          arguments = { action, uri, range, newf },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client:request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = fname,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range["end"].line + 1,
            endOffset = range["end"].character + 1,
          },
        },
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f)
            return vim.fn.fnamemodify(f, ":~:.")
          end,
        }, function(f)
          if f and f:find("^Enter new path") then
            vim.ui.input({
              prompt = "Enter move destination:",
              default = vim.fn.fnamemodify(fname, ":h") .. "/",
              completion = "file",
            }, function(newf)
              return newf and move(newf)
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end,
}
