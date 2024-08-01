return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = function()
    local icons = require("config.icons")

    return {
      popup_border_style = "rounded",
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = icons.file_system.folder.arrow_closed,
          expander_expanded = icons.file_system.folder.arrow_open,
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            deleted = icons.git.deleted,
            renamed = icons.git.renamed,
            untracked = icons.git.untracked,
            ignored = icons.git.ignored,
            unstaged = icons.git.unstaged,
            staged = icons.git.staged,
            conflict = icons.git.conflict,
          },
        },
        icon = {
          folder_closed = icons.file_system.folder.default,
          folder_open = icons.file_system.folder.open,
          folder_empty = icons.file_system.folder.empty,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          visible = true,
        },
      },
      event_handlers = {
        -- close neotree when a file is opened
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    }
  end,
  keys = {
    { "<leader>e", "<cmd>Neotree filesystem toggle<cr>", desc = "Explorer Neotree" },
    {
      "<leader>ge",
      "<cmd>Neotree git_status toggle<cr>",
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      "<cmd>Neotree buffers toggle<cr>",
      desc = "Buffer Explorer",
    },
  },
}
