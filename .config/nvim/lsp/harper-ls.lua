---@type vim.lsp.Config
return {
  cmd = { "harper-ls", "--stdio" },
  single_file_support = true,
  filetypes = {
    "html",
    "lua",
    "markdown",
    "nix",
    "typescript",
    "typescriptreact",
    "tex",
  },
  settings = {
    ["harper-ls"] = {
      userDictPath = "~/.dotfiles/.config/nvim/spell/en.utf-8.add",
      linters = {
        ToDoHyphen = false,
        SentenceCapitalization = true,
        SpellCheck = true,
      },
      isolateEnglish = true,
      markdown = {
        IgnoreLinkTitle = true,
      },
    },
  },
}
