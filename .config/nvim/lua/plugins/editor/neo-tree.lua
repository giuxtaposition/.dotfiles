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
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = icons.git.unstaged,
            staged = icons.git.staged,
          },
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
