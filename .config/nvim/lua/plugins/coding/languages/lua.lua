vim.lsp.enable({
  "lua-ls",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "lua" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["lua"] = { "stylua" },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { plugins = { "nvim-dap-ui" }, types = true },
        { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
      },
    },
  },
  { "DrKJeff16/wezterm-types", lazy = true },
  { "Bilal2453/luvit-meta", lazy = true },
  { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
}
