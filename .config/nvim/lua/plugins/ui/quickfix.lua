vim.pack.add({ { src = "https://github.com/stevearc/quicker.nvim" } })
require("quicker").setup({
  borders = { vert = "│" },
})

vim.keymap.set("n", "<leader>xq", function()
  require("quicker").toggle()
end, { desc = "Toggle quickfix", silent = true })

vim.keymap.set("n", "<leader>xl", function()
  require("quicker").toggle({ loclist = true })
end, { desc = "Toggle loclist list", silent = true })

vim.keymap.set("n", "<leader>xd", function()
  local quicker = require("quicker")
  if quicker.is_open() then
    quicker.close()
  else
    vim.diagnostic.setqflist()
  end
end, { desc = "Toggle diagnostics", silent = true })
