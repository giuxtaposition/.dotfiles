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
      },
      accept = { auto_brackets = { enabled = true } },
      trigger = { signature_help = { enabled = true } },
      windows = {
        autocomplete = {
          -- draw = "reversed",
          border = "single",
          ---@param ctx blink.cmp.CompletionRenderContext
          ---@returns blink.cmp.Component[]
          draw = function(ctx)
            local isCopilot = ctx.item.source_name == "copilot"

            return {
              " ",
              {
                ctx.label,
                ctx.kind == "Snippet" and "~" or nil,
                (ctx.item.labelDetails and ctx.item.labelDetails.detail) and ctx.item.labelDetails.detail or "",
                fill = true,
                hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
                max_width = 50,
              },
              " ",
              {
                isCopilot and require("config.ui.icons").kinds.Copilot or ctx.kind_icon,
                ctx.icon_gap,
                isCopilot and "Copilot" or ctx.kind,
                hl_group = ("BlinkCmpKind" .. ctx.kind),
              },
              " ",
            }
          end,
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
      sources = {
        providers = {
          lsp = { fallback_for = { "lazydev" } },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
          },
        },
        completion = {
          enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
        },
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
