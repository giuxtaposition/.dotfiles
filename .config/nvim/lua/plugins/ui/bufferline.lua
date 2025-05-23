return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  version = "*",
  opts = function()
    return {
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
    }
  end,
  keys = {
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick a buffer to open" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Select a buffer to close" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
}
