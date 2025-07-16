---@module 'blink.cmp'
return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
    },
    version = "1.*",
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
        completion = { menu = { auto_show = true } },
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
        list = {
          -- Insert items while navigating the completion list.
          selection = { preselect = true, auto_insert = false },
          max_items = 10,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "emoji" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = 93,
            min_keyword_length = 2,
            opts = { insert = true },
          },
        },
        per_filetype = {
          codecompanion = { "codecompanion", "buffer" },
        },
      },
      signature = {
        enabled = true,
      },
      appearance = {
        kind_icons = require("config.ui.icons").kinds,
      },
      fuzzy = {
        implementation = "prefer_rust",
        prebuilt_binaries = {
          download = true,
        },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- Extend neovim's client capabilities with the completion ones.
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
    end,
  },
}
