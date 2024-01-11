return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- disable netrw as suggested by nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- change color for arrows in tree
      vim.cmd([[ highlight NvimTreeIndentMarker guifg=#6c7086]])

      local nvimtree = require("nvim-tree")

      nvimtree.setup({
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        renderer = {
          icons = {
            glyphs = {
              folder = {
                arrow_closed = "", -- when folder is closed
                arrow_open = "", -- when folder is open
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
        actions = {
          open_file = {
            window_picker = {
              enable = false,
            },
            quit_on_open = true,
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
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      {
        "<leader>fx",
        "<cmd>Telescope resume<cr>",
        desc = "Resume last telescope window",
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
  },
}
