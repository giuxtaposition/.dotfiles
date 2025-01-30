---@module 'blink.cmp'
return {
  {
    -- enabled = false,
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        dev = true,
        "giuxtaposition/blink-cmp-copilot",
      },
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
        cmdline = {
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
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
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
