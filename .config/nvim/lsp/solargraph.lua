---@type vim.lsp.Config
return {
  cmd = { "solargraph", "stdio" },
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
  init_options = { formatting = true },
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".gem", ".git" },
}
