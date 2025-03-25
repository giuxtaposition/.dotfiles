return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = {
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
        },
      },
    },
  },
}
