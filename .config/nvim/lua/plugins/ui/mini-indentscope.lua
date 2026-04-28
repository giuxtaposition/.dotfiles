-- Lazy-loaded: indentscope deferred to first buffer read
vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    vim.pack.add({ { src = "https://github.com/nvim-mini/mini.indentscope" } })

    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "dashboard" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
})
