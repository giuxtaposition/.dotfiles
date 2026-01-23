vim.pack.add({
  {
    src = "https://github.com/rafamadriz/friendly-snippets",
  },
  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    version = vim.version.range("^2"),
  },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
})

local ls = require("luasnip")
ls.setup({
  history = true,
  delete_check_events = "TextChanged",
})

require("luasnip.loaders.from_vscode").lazy_load()

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
  snippets = {
    preset = "luasnip",
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
})

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
