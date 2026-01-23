vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
  },
  {
    src = "https://github.com/akinsho/bufferline.nvim",
  },
})

local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>bp", "<cmd>BufferLinePick<cr>", "Pick a buffer to open")
set_keymap("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", "Select a buffer to close")
set_keymap("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", "Delete other buffers")
set_keymap("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", "Delete buffers to the right")
set_keymap("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", "Delete buffers to the left")
set_keymap("n", "[b", "<cmd>BufferLineCyclePrev<cr>", "Prev buffer")
set_keymap("n", "]b", "<cmd>BufferLineCycleNext<cr>", "Next buffer")

require("bufferline").setup({
  highlights = require("catppuccin.special.bufferline").get_theme(),
  options = {
    close_command = function(n)
      require("mini.bufremove").delete(n, false)
    end,
    indicator = { style = "underline" },
    show_buffer_close_icons = false,
    show_close_icon = false,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icons = require("config.ui.icons").diagnostics
      local icon = level:match("error") and icons.error or icons.warn
      return icon .. " " .. count
    end,
  },
})
