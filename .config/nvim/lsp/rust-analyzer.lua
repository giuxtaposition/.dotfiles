---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  single_file_support = true,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      inlayHints = {
        closingBraceHints = { enable = true },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
  on_attach = function(_, bufnr)
    local opts = function(desc)
      return { silent = true, buffer = bufnr, desc = desc }
    end
    vim.keymap.set("n", "gra", function()
      vim.cmd.RustLsp("codeAction")
    end, opts("Rust code actions"))
    vim.keymap.set("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, opts("Rust hover actions"))
  end,
}
