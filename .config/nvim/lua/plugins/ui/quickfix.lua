vim.pack.add({
  {
    src = "https://github.com/stevearc/quicker.nvim",
  },
})

local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>xq", function()
  require("quicker").toggle()
end, "Toggle quickfix")

set_keymap("n", "<leader>xl", function()
  require("quicker").toggle({ loclist = true })
end, "Toggle loclist list")

set_keymap("n", "<leader>xd", function()
  local quicker = require("quicker")

  if quicker.is_open() then
    quicker.close()
  else
    vim.diagnostic.setqflist()
  end
end, "Toggle diagnostics")

require("quicker").setup({
  borders = {
    vert = "│",
  },
})
