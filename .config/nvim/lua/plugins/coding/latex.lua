-- Lazy-loaded: VimTeX only needed for LaTeX files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "bib" },
  once = true,
  callback = function()
    vim.pack.add({ { src = "https://github.com/lervag/vimtex" } })
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
    vim.g.vimtex_quickfix_method = "pplatex"
  end,
})
