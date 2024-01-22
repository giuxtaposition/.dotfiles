return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.cmd([[ highlight NvimTreeIndentMarker guifg=#6c7086]])

      local nvimtree = require("nvim-tree")
      local icons = require("giuxtaposition.config.icons")

      nvimtree.setup({
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        diagnostics = {
          enable = true,
          icons = {
            hint = icons.diagnostics.hint,
            info = icons.diagnostics.info,
            warning = icons.diagnostics.warn,
            error = icons.diagnostics.error,
          },
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            resize_window = true,
            quit_on_open = true,
          },
        },
        renderer = {
          root_folder_label = false,
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = vim.list_extend(icons.file_system, icons.git),
          },
        },
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        git = {
          ignore = true,
        },
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
  },
}
