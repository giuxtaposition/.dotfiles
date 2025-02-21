---@module 'blink.cmp'
return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      "rafamadriz/friendly-snippets",
      "giuxtaposition/blink-cmp-copilot",
      "moyiz/blink-emoji.nvim",
    },
    version = false,
    build = "nix run .#build-plugin",
    opts = {
      keymap = {
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
      cmdline = {
        keymap = {
          preset = "super-tab",
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = "single",
          draw = {
            align_to = "label", -- or 'none' to disable
            padding = 1,
            gap = 4,
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
          },
        },
        documentation = {
          auto_show = true,
        },
        ghost_text = {
          enabled = true,
        },
        list = {
          -- Insert items while navigating the completion list.
          selection = { preselect = true, auto_insert = false },
          max_items = 10,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot", "emoji" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = 93,
            min_keyword_length = 2,
            opts = { insert = true },
          },
        },
      },
      signature = {
        enabled = true,
      },
      appearance = {
        kind_icons = require("config.ui.icons").kinds,
      },
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
