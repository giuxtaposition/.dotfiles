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
        -- accept = "<CR>",
        -- select_prev = { "<C-k>" },
        -- select_next = { "<C-j>" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
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
