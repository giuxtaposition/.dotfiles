return {
  -- make API requests in nvim
  "mistweaverco/kulala.nvim",
  config = function()
    vim.filetype.add({
      extension = {
        ["http"] = "http",
      },
    })
    require("kulala").setup()
  end,
}
