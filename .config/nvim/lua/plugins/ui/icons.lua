vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
  },
})

require("nvim-web-devicons").setup({
  override_by_extension = {
    ["component-spec.ts"] = { icon = "", color = "#519ABA", cterm_color = "74", name = "SpecTs" },
    ["api-spec.ts"] = { icon = "", color = "#519ABA", cterm_color = "74", name = "SpecTs" },
    ["integration-spec.ts"] = { icon = "", color = "#519ABA", cterm_color = "74", name = "SpecTs" },
  },
})
