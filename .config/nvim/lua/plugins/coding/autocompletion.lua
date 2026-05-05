vim.pack.add({
  {
    src = "https://github.com/rafamadriz/friendly-snippets",
  },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
})

require("blink.cmp").setup({
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
        gap = 2,
        columns = {
          { "kind_icon", "kind", gap = 1 },
          { "label", "label_description", gap = 1 },
        },
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
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
      i18n = { name = "i18n", module = "config.i18n-completion" },
    },
    per_filetype = {
      typescript = { "lsp", "path", "snippets", "buffer", "lazydev", "i18n" },
      typescriptreact = { "lsp", "path", "snippets", "buffer", "lazydev", "i18n" },
      javascript = { "lsp", "path", "snippets", "buffer", "lazydev", "i18n" },
      javascriptreact = { "lsp", "path", "snippets", "buffer", "lazydev", "i18n" },
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
})

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
