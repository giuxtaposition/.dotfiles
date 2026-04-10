---@type vim.lsp.Config
return {
  cmd = { "kotlin-language-server" },
  filetypes = { "kotlin" },
  root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts" },
  single_file_support = true,
}
