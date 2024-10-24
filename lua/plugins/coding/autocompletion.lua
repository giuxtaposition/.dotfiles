return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = "rafamadriz/friendly-snippets",
    version = false,
    dev = true,
    build = "nix run .#build-plugin",
    opts = {
      keymap = {
        accept = "<CR>",
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
      },
      kind_icons = require("config.icons").kinds,
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false, auto_trigger = true, keymap = { accept = "<M-CR>" } },
      panel = { enabled = true },
    },
  },
}
