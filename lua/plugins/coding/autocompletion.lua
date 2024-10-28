return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = false,
    build = "nix run .#build-plugin",
    opts = {
      keymap = {
        accept = "<CR>",
        select_prev = { "<C-k>" },
        select_next = { "<C-j>" },
      },
      nerd_font_variant = "mono",
      accept = { auto_brackets = { enabled = true } },
      trigger = { signature_help = { enabled = true } },
      windows = {
        autocomplete = {
          draw = "reversed",
          border = "single",
        },
        documentation = {
          border = "single",
          auto_show = true,
        },
        ghost_text = {
          enabled = true,
        },
      },
      kind_icons = require("config.ui.icons").kinds,
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false, auto_trigger = true, keymap = { accept = "<M-CR>" } },
      panel = { enabled = false },
    },
  },
}
