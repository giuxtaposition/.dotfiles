---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    -- css
    "css",
    "less",
    "sass",
    "scss",
    -- js
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    -- mixed
    "vue",
    "svelte",
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
      includeLanguages = {
        eelixir = "html-eex",
        elixir = "phoenix-heex",
        eruby = "erb",
        heex = "phoenix-heex",
        htmlangular = "html",
        templ = "html",
      },
    },
  },
  before_init = function(_, config)
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.editor then
      config.settings.editor = {}
    end
    if not config.settings.editor.tabSize then
      config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
      on_dir(nil)
      return
    end

    local pkg = vim.fs.find("package.json", {
      path = vim.fs.dirname(fname),
      upward = true,
    })[1]

    if not pkg then
      on_dir(nil)
      return
    end

    local contents = vim.fn.readfile(pkg)
    if not contents or #contents == 0 then
      on_dir(nil)
      return
    end

    local ok, data = pcall(vim.fn.json_decode, table.concat(contents, "\n"))
    if not ok or type(data) ~= "table" then
      on_dir(nil)
      return
    end

    local deps = data.dependencies or {}
    local dev_deps = data.devDependencies or {}

    if deps.tailwindcss or dev_deps.tailwindcss then
      on_dir(vim.fs.dirname(pkg))
    else
      on_dir(nil)
    end
  end,
}
