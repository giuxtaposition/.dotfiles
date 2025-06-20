return {
  default_config = {
    cmd = { "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    root_markers = { "Gemfile", ".git" },
    init_options = {
      formatter = "auto",
    },
    single_file_support = true,
  },
}
