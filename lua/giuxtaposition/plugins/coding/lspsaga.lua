return {
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup({ -- keybinds for navigation in lspsaga window
        scroll_preview = { scroll_down = "<C-j>", scroll_up = "<C-k>" },
        -- use enter to open file with definition preview
        definition = {
          keys = {
            edit = "<CR>",
            vsplit = "v",
            split = "h",
          },
        },
        finder = {
          keys = {
            edit = "<CR>",
            toggle_or_open = "<TAB>",
            vsplit = "v",
            split = "h",
          },
        },
        rename = {
          keys = {
            quit = "<C-q>",
          },
          in_select = false,
        },
        ui = {
          kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
          devicon = true,
          expand = "󰁌",
          collapse = "󰡍",
          code_action = require("giuxtaposition.config.icons").hint,
        },
      })
    end,
  },
}
