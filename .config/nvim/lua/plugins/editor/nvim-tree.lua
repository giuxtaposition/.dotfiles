return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.cmd([[ highlight NvimTreeIndentMarker guifg=#6c7086]])

      local nvimtree = require("nvim-tree")

      nvimtree.setup({
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
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
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "󰈚",
              symlink = "",
              folder = {
                default = "",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        git = {
          ignore = false,
        },
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
  },
}
