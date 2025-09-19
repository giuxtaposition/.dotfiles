return {
  "nvim-mini/mini.indentscope",
  opts = {
    symbol = "│",
    options = { try_as_border = true },
  },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "dashboard",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
