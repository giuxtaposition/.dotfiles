vim.lsp.enable({
  "texlab",
})

return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
      vim.g.vimtex_quickfix_method = "pplatex"
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
      { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
    },
  },
}
