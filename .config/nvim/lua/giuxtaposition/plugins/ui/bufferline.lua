return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  version = "*",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
  opts = function()
    return {
      options = {
        separator_style = "slant",
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(count, _, _, _)
          if count > 9 then
            return "9+"
          end
          return tostring(count)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "EXPLORER",
            highlight = "Directory",
            text_align = "center",
          },
        },
        hover = {
          enabled = true,
          delay = 0,
          reveal = { "close" },
        },
      },
      highlights = {
        fill = {
          bg = require("giuxtaposition.config.colors").bg_dark,
        },
        separator = {
          fg = require("giuxtaposition.config.colors").bg_dark,
        },
        separator_visible = {
          fg = require("giuxtaposition.config.colors").bg_dark,
        },
        separator_selected = {
          fg = require("giuxtaposition.config.colors").bg_dark,
        },
        tab_separator = {
          fg = require("giuxtaposition.config.colors").bg_dark,
        },
        tab_separator_selected = {
          fg = require("giuxtaposition.config.colors").bg_dark,
        },
      },
    }
  end,
}
