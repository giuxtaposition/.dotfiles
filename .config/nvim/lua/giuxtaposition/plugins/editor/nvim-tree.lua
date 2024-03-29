return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.cmd([[ highlight NvimTreeIndentMarker guifg=#6c7086]])

      local nvimtree = require("nvim-tree")
      local icons = require("giuxtaposition.config.icons")

      nvimtree.setup({
        filters = {
          dotfiles = false,
        },
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
          update_cwd = false,
        },
        view = {
          adaptive_size = false,
          side = "left",
          width = 30,
          preserve_window_proportions = true,
          signcolumn = "yes",
        },
        git = {
          enable = true,
          ignore = false,
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
          group_empty = true,
          root_folder_label = false,
          highlight_git = true,
          highlight_opened_files = "none",
          indent_width = 2,
          indent_markers = {
            enable = false,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = vim.list_extend(icons.file_system, icons.git),
            git_placement = "before",
            padding = " ",
          },
        },

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
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
  },
}
