vim.pack.add({
  {
    src = "https://github.com/windwp/nvim-ts-autotag",
  },
  {
    src = "https://github.com/dmmulroy/tsc.nvim",
  },
  {
    src = "https://github.com/dmmulroy/ts-error-translator.nvim",
  },
})

local util = require("config.util")

local set_keymap = util.keys.set

util.lsp.register_hook(function(client, bufnr)
  -- Typescript specific keymaps.
  if client.name == "vtsls" then
    set_keymap(
      "n",
      "<leader>co",
      require("config.util").lsp.action["source.organizeImports"],
      "Organize Imports",
      { buffer = bufnr }
    )
    set_keymap(
      "n",
      "<leader>cM",
      require("config.util").lsp.action["source.addMissingImports.ts"],
      "Add missing imports",
      { buffer = bufnr }
    )
    set_keymap(
      "n",
      "<leader>cu",
      require("config.util").lsp.action["source.removeUnused.ts"],
      "Remove unused imports",
      { buffer = bufnr }
    )
    set_keymap(
      "n",
      "<leader>cD",
      require("config.util").lsp.action["source.fixAll.ts"],
      "Fix all diagnostics",
      { buffer = bufnr }
    )
    set_keymap("n", "<leader>cV", function()
      require("config.util").lsp.execute({ command = "typescript.selectTypeScriptVersion" })
    end, "Select TS workspace version", { buffer = bufnr })
  end
end)

require("nvim-ts-autotag").setup()

require("tsc").setup({
  use_trouble_qflist = true,
  auto_close_qflist = true,
})

require("ts-error-translator").setup({ auto_attach = true, servers = {
  "vtsls",
} })
